require "sinatra"
require "that_language"

module ThatLanguage
  module Service
    class Application < Sinatra::Application
      get '/language_code' do
        render_json language_code: language_code
      end

      post '/language_code' do
        render_json language_code: language_code
      end

      get '/detect' do
        render_json({
          language_code: detect.language_code,
          confidence: detect.confidence
        })
      end

      post '/detect' do
        render_json({
          language_code: detect.language_code,
          confidence: detect.confidence
        })
      end

      get '/details' do
        details.to_json
      end

      post '/details' do
        details.to_json
      end

      get '/version' do
        render_json version: ThatLanguage::VERSION
      end

    private

      def render_json(hash)
        hash.to_json
      end

      def language_code
        @language_code ||= ThatLanguage.language_code(text)
      end

      def detect
        @detect ||= ThatLanguage.detect(text)
      end

      def details
        @details ||= ThatLanguage.details(text)
      end

      def text
        params['text']
      end
    end
  end
end
