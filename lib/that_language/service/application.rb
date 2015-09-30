require "sinatra"
require "that_language"

module ThatLanguage
  module Service
    class Application < Sinatra::Application
      get '/' do
        ThatLanguage.language_code(params['text'])
      end

      post '/' do
        ThatLanguage.language_code(params['text'])
      end

      # get '/detect' do
      #   ThatLanguage.detect(params['text']).to_json
      # end
      #
      # post '/detect' do
      #   ThatLanguage.detect(params['text']).to_json
      # end

      get '/details' do
        ThatLanguage.details(params['text']).to_json
      end

      post '/details' do
        ThatLanguage.details(params['text']).to_json
      end

      get '/language_code' do
        ThatLanguage.language_code(params['text']).to_json
      end

      post '/language_code' do
        ThatLanguage.language_code(params['text']).to_json
      end
    end
  end
end
