require 'spec_helper'
require 'support/that_language_service_spec_helper'

describe ThatLanguage::Service::Application do
  include ThatLanguageServiceSpecHelper

  payload = "Hallo Welt"

  describe_endpoint "/language", payload: payload do
    it { is_expected.to include("language" => "German") }
  end

  describe_endpoint "/language_code", payload: payload do
    it { is_expected.to include("language_code" => "de") }
  end

  describe_endpoint "/detect", payload: payload do
    it { is_expected.to include("language" => "German") }
    it { is_expected.to include("language_code" => "de") }
    it { is_expected.to include("confidence" => 0.5) }
    it { is_expected.not_to include("value") }
    it { is_expected.not_to include("hit_ratio") }
    it { is_expected.not_to include("hit_count") }
    it { is_expected.not_to include("words_count") }
  end

  describe_endpoint "/details", payload: payload do
    it { is_expected.to include("results") }

    describe "results" do
      subject(:results) { json["results"] }

      it { is_expected.to be_an(Array) }

      describe "an entry" do
        subject { results.first }

        it { is_expected.to include("language" => "German") }
        it { is_expected.to include("language_code" => "de") }
        it { is_expected.to include("confidence" => 0.5) }
        it { is_expected.to include("value" => 1) }
        it { is_expected.to include("hit_ratio" => 0.5) }
        it { is_expected.to include("hit_count" => 1) }
        it { is_expected.to include("words_count" => 2) }
      end
    end
  end

  describe_endpoint "/available" do
    it { is_expected.to include("available") }

    describe "available" do
      subject { json["available"] }

      it { is_expected.to be_a(Hash) }

      it { is_expected.to include("de" => "German") }
      it { is_expected.to include("en" => "English") }
    end
  end

  describe_endpoint "/available_languages" do
    it { is_expected.to include("available_languages") }

    describe "available_languages" do
      subject { json["available_languages"] }

      it { is_expected.to be_a(Array) }

      it { is_expected.to include("German") }
      it { is_expected.to include("English") }
    end
  end

  describe_endpoint "/available_language_codes" do
    it { is_expected.to include("available_language_codes") }

    describe "available_language_codes" do
      subject { json["available_language_codes"] }

      it { is_expected.to be_a(Array) }

      it { is_expected.to include("ar") }
      it { is_expected.to include("cs") }
      it { is_expected.to include("da") }
      it { is_expected.to include("de") }
      it { is_expected.to include("el") }
      it { is_expected.to include("en") }
      it { is_expected.to include("es") }
      it { is_expected.to include("fa") }
      it { is_expected.to include("fi") }
      it { is_expected.to include("fr") }
      it { is_expected.to include("he") }
      it { is_expected.to include("hu") }
      it { is_expected.to include("it") }
      it { is_expected.to include("ja") }
      it { is_expected.to include("ko") }
      it { is_expected.to include("nl") }
      it { is_expected.to include("no") }
      it { is_expected.to include("pl") }
      it { is_expected.to include("pt") }
      it { is_expected.to include("ru") }
      it { is_expected.to include("sv") }
      it { is_expected.to include("tr") }
      it { is_expected.to include("vi") }
      it { is_expected.to include("zh") }
    end
  end

  describe_endpoint "/version" do
    it { is_expected.to include("version" => "0.1.2") }
  end

  context "with a referer" do
    describe_endpoint "/version", rack_env: { "HTTP_REFERER" => "http://example.com" } do
      # NOOP (run only the specs included in the `describe_endpoint` macro)
    end
  end
end
