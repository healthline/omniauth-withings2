require 'spec_helper'

describe "OmniAuth::Strategies::Withings2" do
  subject do
    OmniAuth::Strategies::Withings2.new(nil, @options || {})
  end

  describe 'response_type' do
    it 'includes :code' do
      expect(subject.options["response_type"]).to include('code')
    end
  end

  describe 'authorize_options' do
    it 'includes :scope' do
      expect(subject.options["authorize_options"]).to include(:scope)
    end

    it 'includes :response_type' do
      expect(subject.options["authorize_options"]).to include(:response_type)
    end

    it 'includes :redirect_uri' do
      expect(subject.options["authorize_options"]).to include(:redirect_uri)
    end
  end

  context 'client options' do
    it 'has correct OAuth endpoint' do
      expect(subject.options.client_options.site).to eq('https://account.withings.com')
    end

    it 'has correct authorize url' do
      expect(subject.options.client_options.authorize_url).to eq('https://account.withings.com/oauth2_user/authorize2')
    end

    it 'has correct token url' do
      expect(subject.options.client_options.token_url).to eq('https://wbsapi.withings.net/v2/oauth2')
    end
  end

  context 'auth header' do
    before :each do
      subject.options.client_id = 'testclientid'
      subject.options.client_secret = 'testclientsecret'
    end

    it 'returns the correct authorization header value' do
      expect(subject.basic_auth_header).to eq('Basic ' + Base64.strict_encode64("testclientid:testclientsecret"))
    end
  end

  context 'uid' do
    before :each do
      access_token = double('access_token')
      allow(access_token).to receive('params') { { 'userid' => '123ABC' } }
      allow(subject).to receive(:access_token) { access_token }
    end

    it 'returns the correct id from raw_info' do
      expect(subject.uid).to eq('123ABC')
    end
  end
end
