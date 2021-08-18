require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Withings2 < OmniAuth::Strategies::OAuth2

      option :name, 'withings2'
      option :client_options, {
        :site          => 'https://account.withings.com',
        :authorize_url => 'https://account.withings.com/oauth2_user/authorize2',
        :token_url     => 'https://wbsapi.withings.net/v2/oauth2',
      }

      option :response_type, 'code'
      option :authorize_options, %i(scope response_type redirect_uri)
      option :access_token_params, { action: 'requesttoken' }

      def build_access_token
        options.token_params.merge!(
          headers: { 'Authorization' => basic_auth_header }
        )
        super
      end

      def basic_auth_header
        "Basic " + Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")
      end

      # def query_string
      #   # Using state and code params in the callback_url causes a mismatch with
      #   # the value set in the withings2 application configuration, so we're skipping them
      #   ''
      # end

      uid do
        access_token.params['userid']
      end
    end
  end
end
