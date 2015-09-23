require "sinatra"
require "that_language"

module ThatLanguage
  module Service
    class Application < Sinatra::Application
      get '/' do
        ThatLanguage.locale(params['text']).locale
      end

      post '/' do
        ThatLanguage.locale(params['text']).locale
      end

      get '/details' do
        ThatLanguage.details(params['text']).to_json
      end

      post '/details' do
        ThatLanguage.details(params['text']).to_json
      end

      get '/locale' do
        ThatLanguage.locale(params['text']).to_json
      end

      post '/locale' do
        ThatLanguage.locale(params['text']).to_json
      end
    end
  end
end
