require 'rack/test'
require 'json'

module ThatLanguageServiceSpecHelper
  include Rack::Test::Methods

  def self.included(base)
    base.extend(ClassMethods)

    base.class_eval do
      subject { last_response }
    end
  end

  def app
    @app ||= described_class
  end

  module ClassMethods
    def describe_endpoint(endpoint, methods: [:get, :post], &block)
      methods.each do |method|
        describe("#{method.to_s.upcase} #{endpoint}") do
          let(:response) { last_response }
          let(:body) { response.body }

          before do
            params = payload.nil? ? {} : { text: payload }
            send(method, endpoint, params)
          end

          it { is_expected.to be_ok }

          describe "header" do
            subject(:header) { response.header }

            specify "Content-Type is JSON" do
              expect(header["Content-Type"]).to eq("application/json")
            end
          end

          describe "response as a json" do
            subject(:json) { JSON.parse(response.body) }

            it { is_expected.to be_a(Hash) }
            class_eval(&block)
          end
        end
      end
    end
  end
end
