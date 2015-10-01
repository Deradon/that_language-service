require 'spec_helper'
require 'rack/test'
require 'json'

# TODO: Complete all the specs
describe ThatLanguage::Service::Application do
  include Rack::Test::Methods

  def app
    @app ||= described_class
  end

  describe "GET /language_code?text=Hallo" do
    subject { last_response }
    before { get('/language_code?text=Hallo') }

    it { is_expected.to be_ok }

    describe "response as a json" do
      subject { JSON.parse(last_response.body) }

      it { is_expected.to be_a(Hash) }
      it { is_expected.to include("language_code" => "de") }
    end
  end

  describe "GET /detect?text=Hallo" do
    subject { last_response }
    before { get('/detect?text=Hallo') }

    it { is_expected.to be_ok }

    describe "response as a json" do
      subject { JSON.parse(last_response.body) }

      it { is_expected.to be_a(Hash) }
      it { is_expected.to include("language_code" => "de") }
      it { is_expected.to include("confidence" => 1.0) }
      it { is_expected.to include("value" => 1.0) }
      it { is_expected.to include("hit_ratio" => 1.0) }
      it { is_expected.to include("hit_count" => 1.0) }
      it { is_expected.to include("words_count" => 1.0) }
    end
  end
end
