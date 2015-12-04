require 'spec_helper'
require 'rack/test'
require 'json'

describe ThatLanguage::Service::Application do
  include Rack::Test::Methods

  def app
    @app ||= described_class
  end

  subject { last_response }

  describe "GET /language_code?text=Hallo" do
    before { get('/language_code?text=Hallo') }

    it { is_expected.to be_ok }

    describe "response as a json" do
      subject { JSON.parse(last_response.body) }

      it { is_expected.to be_a(Hash) }
      it { is_expected.to include("language_code" => "de") }
    end
  end

  describe "GET /detect?text=Hallo" do
    before { get('/detect?text=Hallo') }

    it { is_expected.to be_ok }

    describe "response as a json" do
      subject { JSON.parse(last_response.body) }

      it { is_expected.to be_a(Hash) }
      it { is_expected.to include("language_code" => "de") }
      it { is_expected.to include("confidence" => 1.0) }
      it { is_expected.not_to include("value") }
      it { is_expected.not_to include("hit_ratio") }
      it { is_expected.not_to include("hit_count") }
      it { is_expected.not_to include("words_count") }
    end
  end

  describe "GET /details?text=Hallo" do
    before { get('/details?text=Hallo') }

    it { is_expected.to be_ok }

    describe "response as a json" do
      subject(:json) { JSON.parse(last_response.body) }

      it { is_expected.to be_a(Hash) }
      it { is_expected.to include("results") }

      describe "results" do
        subject(:results) { json["results"] }

        it { is_expected.to be_a(Array) }

        describe "an entry" do
          subject { results.first }

          it { is_expected.to include("language_code" => "de") }
          it { is_expected.to include("confidence" => 1.0) }
          it { is_expected.to include("value" => 1) }
          it { is_expected.to include("hit_ratio" => 1) }
          it { is_expected.to include("hit_count" => 1) }
          it { is_expected.to include("words_count" => 1) }
        end
      end
    end
  end

  describe "GET /version" do
    before { get('/version') }

    it { is_expected.to be_ok }

    describe "response as a json" do
      subject { JSON.parse(last_response.body) }

      it { is_expected.to be_a(Hash) }
      it { is_expected.to include("version" => "0.1.0.pre3") }
    end
  end
end
