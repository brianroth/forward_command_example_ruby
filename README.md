# Ruby TMS SMS Forward Command Example

This repo provides a simple Ruby Sinatra application as an example of how to
write a service to integrate with TMS for providing information via SMS to 
users based on user input.

## Install It

```
git clone git@github.com:govdelivery/forward_command_example_ruby.git
cd forward_command_example_ruby
bundle install
```
## Test It

```
bundle exec rspec spec/knowit_test.rb
```

## Run It

```
bundle exec unicorn
```

## Manually Use It

```
curl -X POST http://localhost:8080 -d 'sms_body=St.%20Paul'
```
