require "spec_helper"

describe Weather do

  context "with a response",  :vcr => {:cassette_name => 'test_results'} do
    before :each do
      post '/', sms_body: 'St.%20Paul'
    end

    it { expect(last_response.headers['Content-Type']).to eq('text/plain;charset=utf-8') }
    it { expect(last_response).to be_ok }

    it 'returns the result' do
      expect(last_response.body).to match(/Current Weather: .* degrees and \w+/) 
    end
  end

  context "with no response", :vcr => {:cassette_name => 'test_no_results'} do
    before :each do
      post '/', sms_body: 'LaLaThisPlaceDoesNotExistLand'
    end

    it { expect(last_response.headers['Content-Type']).to eq('text/plain;charset=utf-8') }
    it { expect(last_response).to be_ok }

    it 'returns the error response' do
      expect(last_response.body).to eq("We are sorry, but the message you sent is not valid. Please check your text and try it again.")
    end
  end

  context "with a malformed request" do
    before :each do
      post '/', body: 'St.%20Paul' #invalid param name
    end

    it { expect(last_response.headers['Content-Type']).to eq('text/plain;charset=utf-8') }
    it { expect(last_response).to be_ok }

    it 'returns the error response' do
      expect(last_response.body).to eq("We are sorry, but the message you sent is not valid. Please check your text and try it again.")
    end
  end


  context "with an invalid route" do
    before :each do
      post '/config/settings.yml', sms_body: 'St.%20Paul'
    end

    it { expect(last_response.headers['Content-Type']).to eq('text/plain;charset=utf-8') }
    it { expect(last_response.status).to eq(404) }

    it 'returns the error response' do
      expect(last_response.body).to eq("We are sorry, but the message you sent is not valid. Please check your text and try it again.")
    end
  end

  context "when the remote server" do
    context "responds with a error" do
      before :each do
        stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?q=St.%20Paul&units=imperial").to_return(:body => '', :status => 500)
        post '/', sms_body: 'St.%20Paul'
      end

      it { expect(last_response.headers['Content-Type']).to eq('text/plain;charset=utf-8') }
      it { expect(last_response).to be_ok }

      it 'returns the error response' do
        expect(last_response.body).to eq("We are sorry, but the message you sent is not valid. Please check your text and try it again.")
      end
    end

    context "is not found" do
      before :each do
        stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?q=St.%20Paul&units=imperial").to_return(:body => '', :status => 404)
        post '/', sms_body: 'St.%20Paul'
      end

      it { expect(last_response.headers['Content-Type']).to eq('text/plain;charset=utf-8') }
      it { expect(last_response).to be_ok }

      it 'returns the error response' do
        expect(last_response.body).to eq("We are sorry, but the message you sent is not valid. Please check your text and try it again.")
      end
    end
  end
end
