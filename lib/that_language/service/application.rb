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
        render_json(detect)
      end

      post '/detect' do
        render_json(detect)
      end

      get '/details' do
        render_json details: details
      end

      post '/details' do
        render_json details: details
      end

    private

      def render_json(hash)
        hash.to_json
      end

      def language_code
        ThatLanguage.language_code(text)
      end

      def detect
        ThatLanguage.detect(text)
      end

      def details
        ThatLanguage.details(text)
      end

      def text
        params['text']
      end
    end
  end
end
