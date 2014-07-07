require_relative 'app'
require 'rspec'
require 'rack/test'

describe "Hello application" do
  include ::Rake::Test::Methods

  def app
    ::Sinatra::Application
  end

  it 'says hello' do
    get '/hello'
    expect(last_response).to be_ok
    expect(last_response.body).to eq "Hello, Sinatra"
  end
end
