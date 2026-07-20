require "json"
require "sinatra/base"
require "sinatra/multi_route"
require "that_language"

module ThatLanguage
  module Service
    # Modular style: `require "sinatra"` would boot a classic top-level app with
    # an at_exit server runner, which is wrong for a library gem. config.ru runs
    # this class explicitly.
    class Application < Sinatra::Base
      register Sinatra::MultiRoute

      # Rack::Protection::JsonCsrf answers 403 to any request carrying a
      # cross-origin Referer. This API is public, unauthenticated and read-only,
      # and is deployed with CORS enabled precisely so browsers on other origins
      # can call it -- so the protection would block the intended use case while
      # guarding data that is already public. There is also no session, cookie
      # or state change anywhere in the service for a CSRF to abuse.
      #
      # Revisit this if the service ever gains authentication, sessions, or an
      # endpoint that is not a pure function of its input -- the reasoning above
      # collapses the moment a request carries ambient authority.
      set :protection, except: [:json_csrf]

      route :get, :post, '/language' do
        render_json language: ThatLanguage.language(text)
      end

      route :get, :post, '/language_code' do
        render_json language_code: ThatLanguage.language_code(text)
      end

      route :get, :post, '/detect' do
        render_json({
          language: detect.language,
          language_code: detect.language_code,
          confidence: detect.confidence
        })
      end

      route :get, :post, '/details' do
        render_json ThatLanguage.details(text)
      end

      route :get, :post, '/available' do
        render_json available: ThatLanguage.available
      end

      route :get, :post, '/available_languages' do
        render_json({
          available_languages: ThatLanguage.available_languages
        })
      end

      route :get, :post, '/available_language_codes' do
        render_json({
          available_language_codes: ThatLanguage.available_language_codes
        })
      end

      route :get, :post, '/version' do
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
    end
  end
end
