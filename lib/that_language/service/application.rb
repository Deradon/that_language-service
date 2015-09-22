require "sinatra"
require "detect_language"

module ThatLanguage
  module Service
    class Application < Sinatra::Application
      get '/' do
        DetectLanguage.language(params['text']).locale
      end

      post '/' do
        DetectLanguage.language(params['text']).locale
      end

      get '/details' do
        DetectLanguage.details(params['text']).to_json
      end

      post '/details' do
        DetectLanguage.details(params['text']).to_json
      end

      get '/language' do
        DetectLanguage.language(params['text']).to_json
      end

      post '/language' do
        DetectLanguage.language(params['text']).to_json
      end
    end
  end
end
