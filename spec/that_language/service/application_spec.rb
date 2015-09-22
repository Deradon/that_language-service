require 'spec_helper'
require 'rack/test'

# TODO: Complete all the specs
describe ThatLanguage::Service::Application do
  include Rack::Test::Methods

  def app
    @app ||= described_class
  end

  it "respond to /" do
    get '?text=Hallo'
    expect(last_response).to be_ok
  end
end
