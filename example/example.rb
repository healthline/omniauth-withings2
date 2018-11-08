require 'active_support/all'
require 'sinatra'
require 'omniauth-withings2'
require 'pry'
require 'logger'
require 'pp'
require 'httparty'

LOGGER = Logger.new(STDOUT)

DOMAIN = 'http://localhost:4567'
SETTINGS = {
  client_id: ENV['WITHINGS_CLIENT_ID'],
  client_secret: ENV['WITHINGS_CLIENT_SECRET'],
  redirect_uri: DOMAIN + '/auth/withings2/callback'
}

SINCE_HOW_MANY_DAYS = 365
TIME_UNITS_PER_DAY = 60*60*24
ITEMS_PER_PAGE = 10
CATEGORY_REAL_MEASURES = 1

WITHINGS_DATA = {} # In a real app, this should be stored elsewhere!

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :withings2, SETTINGS[:client_id], SETTINGS[:client_secret], { :scope => 'user.info,user.metrics,user.activity', :redirect_uri => SETTINGS[:redirect_uri] }
end

get '/' do
  WITHINGS_DATA = {}
  <<-HTML
  <a href='/auth/withings2'>Sign in with Withings</a>
  HTML
end

get '/auth/withings2/callback' do
  # Do whatever you want with the data
  # MultiJson.encode(request.env['omniauth.auth'])
  WITHINGS_DATA["auth"] = JSON.parse(request.env['omniauth.auth'].to_json)

  <<-HTML
  <a href='/auth/withings2/measurements' target="_blank">Get Measurements</a>
  WITHINGS_DATA:
  <pre>
  #{WITHINGS_DATA}
  </pre>
  WITHINGS_DATA["auth"]["credentials"]["token"]:
  <pre>
  #{WITHINGS_DATA["auth"]["credentials"]["token"]}
  </pre>
  <a href='/auth/withings2'>Re-Sign in with Withings</a>
  HTML
end

get '/auth/withings2/measurements' do
  measurements = get_measurements.to_s

  <<-HTML
  <a href='/auth/withings2/measurements' target="_blank">Get Measurements</a>
  measurements:
  <pre>
  #{measurements}
  </pre>
  <a href='/auth/withings2/measurements' target="_blank">Re-Get Measurements</a>
  <a href='/auth/withings2'>Re-Sign in with Withings</a>
  HTML
end

# See: https://developer.health.nokia.com/oauth2/#tag/measure%2Fpaths%2Fhttps%3A~1~1wbsapi.withings.net~1measure%3Faction%3Dgetmeas%2Fget
# optional parameter keys:
#   :meastype, :category, :startdate, :enddate, :lastupdate, :limit, :offset
def gen_measurement_parameters(parameters = {})
  parameters[:action] = 'getmeas'
  parameters[:access_token] = WITHINGS_DATA["auth"]["credentials"]["token"] 

  # parameters[:meastype] = meastype || 1

  parameters[:category] = parameters[:category] || CATEGORY_REAL_MEASURES

  # parameters[:startdate] = parameters[:startdate_at].to_i if parameters[:startdate_at]
  # parameters[:enddate] = parameters[:enddate_at].to_i if parameters[:enddate_at]
  # parameters[:lastupdate] = parameters[:lastupdate_at].to_i if parameters[:lastupdate_at]

  parameters[:limit] = parameters[:limit] || ITEMS_PER_PAGE
  parameters[:offset] = parameters[:offset] || 0

  parameters
end

def get_measurements()
  parameters = gen_measurement_parameters
  # # OAuth 2.0
  # curl 'https://wbsapi.withings.net/measure?action=getmeas&access_token=[STRING]&meastype=[INTEGER]&category=[INT]&startdate=[INT]&enddate=[INT]&offset=[INT]'
  url = 'https://wbsapi.withings.net/measure'
  
  request_url = url + '?' + parameters.to_query

  response = HTTParty.get(request_url)

  response_body = JSON.parse(response.body)
  response_body_status = response_body['status']

  if response.code == 200 && response_body_status == 0 # Operation was successful  
    return response_body.to_s
  else
    error_data = {
      status_code: response.code,
      response_body_status: response_body_status,
      response_body: response_body       
    }
    raise error_data.to_s
  end
end

LOGGER.info("Server started at: #{DOMAIN}")
