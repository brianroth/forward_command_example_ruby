class Weather < Sinatra::Base
  register Sinatra::ConfigFile
  config_file 'config/settings.yml'
  enable :logging

  before do
    # TMS Forward Commands expect to receive text/plain content
    content_type :text

    # Normalize parameter keys
    params.each_key{|key| params[key] = params[key].strip.downcase }
  end

  not_found do
    # Return our standard error message on a 404
    settings.response[:error]
  end

  post '/' do
    # Assume we're going to send the user an error, unless success occurs
    api_response = settings.response[:error]

    begin
      # Make a request to the OpenWeatherMap API based on what a user's SMS
      # e.g. http://api.openweathermap.org/data/2.5/weather?q=St.%20Paul&units=imperial
      response = connection.get do |req|
        req.url settings.api[:path], q: params[:sms_body], units: settings.api_request[:units]
      end
      
      if !response.body.nil?
        # If we got something back, attempt to build a string to send back to the user via TMS SMS
        api_response = "Current Weather: #{response.body["main"]["temp"]} degrees and #{response.body["weather"][0]["main"]}"
      end

    rescue Exception => e
      # Log if an error occurred. If an error did occur, api_response should still equal settings.response[:error]
      logger.error "An error occurred: #{e}"
    end

    # Send our string that we want to deliver to the user to TMS
    api_response
  end

  private

  def connection
    @connection || Faraday.new(:url => settings.api[:url]) do |faraday|
      faraday.use Faraday::Response::RaiseError
      faraday.adapter Faraday.default_adapter

      # OpenWeatherMap API can return JSON, so let's get that
      faraday.request :json
      faraday.response :json, content_type: "application/json"
    end
  end
end
