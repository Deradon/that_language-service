require "sinatra"
require "sinatra/multi_route"
require "that_language"

module ThatLanguage
  module Service
    class Application < Sinatra::Application
      route :get, :post, '/language' do
        return nothing_to_render unless text?
        render_json language: ThatLanguage.language(text)
      end

      route :get, :post, '/language_code' do
        return nothing_to_render unless text?
        render_json language_code: ThatLanguage.language_code(text)
      end

      route :get, :post, '/detect' do
        return nothing_to_render unless text?
        render_json({
          language: ThatLanguage::Iso639[detect.language_code], # TODO: detect.language
          language_code: detect.language_code,
          confidence: detect.confidence
        })
      end

      route :get, :post, '/details' do
        render_json ThatLanguage.details(text)
      end

      get '/available' do
        render_json available: ThatLanguage.available
      end

      get '/available_languages' do
        render_json({
          available_languages: ThatLanguage.available_languages
        })
      end

      get '/available_language_codes' do
        render_json({
          available_language_codes: ThatLanguage.available_language_codes
        })
      end

      get '/version' do
        render_json version: ThatLanguage::VERSION
      end

    private

      def render_json(obj)
        content_type :json
        obj.to_json
      end

      def detect
        @detect ||= ThatLanguage.detect(text)
      end

      def text
        params['text']
      end

      def text?
        not text.nil? || text.empty?
      end

      def nothing_to_render
        render_json({})
      end
    end
  end
end
