# OmniAuth Withings2 Strategy

This is an OmniAuth OAuth 2.0 strategy for authenticating with the [Withings (formerly Nokia Health) OAuth 2.0 API](see http://developer.withings.com/oauth2/#tag/OAuth-2.0).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-withings2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-withings2


## Get your Oauth credentials

To register your application with Withings and obtain a client id and consumer secret, go to the [Withings developer application registration](https://account.withings.com/partner/account_login?b=add_oauth2).

## Running the example

$ cd example
$ bundle
$ WITHINGS_CLIENT_ID=<your_withings_client_id> WITHINGS_CLIENT_SECRET=<your_withings_client_secret> bundle exec ruby example.rb
Visit http://localhost:4567/ in a browser

## Usage

Add the strategy to your `Gemfile`:

```ruby
gem 'omniauth-withings2'
```

Then integrate the strategy into your middleware:

```ruby
use OmniAuth::Builder do
  provider :withings2,
    ENV['WITHINGS_CLIENT_ID'],
    ENV['WITHINGS_CLIENT_SECRET'],
    scope: 'user.metrics'
end
```

In Rails, create a new file under config/initializers called omniauth.rb to plug the strategy into your middleware stack.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :withings2,
    ENV['WITHINGS_CLIENT_ID'],
    ENV['WITHINGS_CLIENT_SECRET'],
    scope: 'user.metrics'
end
```

In your controller action (responding to /auth/withings2/callback), get the credentials and store them for later interaction with the API:

```ruby
request.env['omniauth.auth']['credentials']
```

### TODO: update
To interact with the Withings API (e.g. retrieve weight measurements recorded by a Nokia/Withings scale):

```ruby
oauth_consumer = OAuth::Consumer.new(
  ENV['WITHINGS_CLIENT_ID'],
  ENV['WITHINGS_CLIENT_SECRET'],
  OmniAuth::Strategies::Withings.consumer_options,
)

api_access_token = OAuth::AccessToken.from_hash(oauth_consumer, {
  oauth_token: withings_user_access_token,
  oauth_token_secret: withings_user_access_token_secret,
})

# Change the uri to access other Withings API endpoints
uri = "https://wbsapi.withings.net/measure?action=getmeas&userid=#{withings_user_id}"

request = api_access_token.get(uri)
JSON.parse(request.body)
```
### END TODO: update

## About OmniAuth

For additional information about OmniAuth, visit [OmniAuth wiki](https://github.com/intridea/omniauth/wiki).

For a short tutorial on how to use OmniAuth in your Rails application, visit [this tutsplus.com tutorial](http://net.tutsplus.com/tutorials/ruby/how-to-use-omniauth-to-authenticate-your-users/).

(The above adapted from [omniauth-fitbit](https://github.com/tkgospodinov/omniauth-fitbit))

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/platejoy/omniauth-withings2.

## Original License

Copyright (c) 2016 TK Gospodinov. See [LICENSE](https://github.com/platejoy/omniauth-withings2/blob/master/LICENSE.md) for details.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
