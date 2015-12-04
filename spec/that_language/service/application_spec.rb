require 'spec_helper'
require 'support/that_language_service_spec_helper'

describe ThatLanguage::Service::Application do
  include ThatLanguageServiceSpecHelper

  describe_endpoint "/language_code", payload: "Hallo" do
    it { is_expected.to include("language_code" => "de") }
  end

  describe_endpoint "/detect", payload: "Hallo" do
    it { is_expected.to include("language_code" => "de") }
    it { is_expected.to include("confidence" => 1.0) }
    it { is_expected.not_to include("value") }
    it { is_expected.not_to include("hit_ratio") }
    it { is_expected.not_to include("hit_count") }
    it { is_expected.not_to include("words_count") }
  end

  describe_endpoint "/details", payload: "Hallo" do
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

  describe_endpoint "/version", methods: [:get] do
    it { is_expected.to include("version" => "0.1.0.pre3") }
  end

  describe_endpoint "/available_language_codes", methods: [:get] do
    it { is_expected.to include("available_language_codes") }

    describe "available_language_codes" do
      subject { json["available_language_codes"] }

      it { is_expected.to be_a(Array) }

      it { is_expected.to include("ar") }
      it { is_expected.to include("br") }
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
      it { is_expected.to include("kr") }
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
end
