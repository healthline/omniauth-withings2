require 'sinatra'
require 'omniauth-withings2'
require 'pry'

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :withings2, ENV['WITHINGS_CLIENT_ID'], ENV['WITHINGS_CLIENT_SECRET'], { :scope => 'user.metrics', :redirect_uri => 'http://localhost:4567/auth/withings2/callback' }
end

get '/' do
  <<-HTML
  <a href='/auth/withings2'>Sign in with Withings</a>
  HTML
end

get '/auth/withings2/callback' do
  # Do whatever you want with the data
  # MultiJson.encode(request.env['omniauth.auth'])
  request.env['omniauth.auth'].to_json
end
