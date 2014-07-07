require 'rspec'
require 'rack/test'

describe 'CRUD Bookmark App' do
  include ::Rack::Test::Methods

  def app
    ::Sinatra::Application
  end

  describe 'POST /bookmarks' do
    it 'creates a new bookmark' do
      get '/bookmarks'
      expect(last_response).to be_ok
      bookmarks = ::JSON.parse(last_response.body)
      last_size = bookmarks.size

      post '/bookmarks', { :url => 'google.com', :title => 'Google' }
      expect(last_response.status).to eq(201)
      expect(last_response.body).to match(/\/bookmarks\/\d+/)

      get '/bookmarks'
      expect(last_response).to be_ok
      bookmarks = ::JSON.parse(last_response.body)
      expect(bookmarks.size).to eq(last_size + 1)
    end
  end

  describe 'PUT /bookmarks/:id' do
    it 'updates a bookmark' do
      post '/bookmarks', { :url => 'google.com', :title => 'Google' }
      expect(last_response.status).to eq(201)
      bookmark_uri = last_response.body
      bookmark_id = bookmark_uri.split('/').last

      put "/bookmarks/#{bookmark_id}", { :title => 'Success' }
      expect(last_response.status).to eq(204)

      get "/bookmarks/#{bookmark_id}"
      expect(last_response.status).to be_ok
      bookmark = ::JSON.parse(last_response.body)
      expect(bookmark['title']).to eq('Success')
    end
  end

  describe 'DELETE /bookmarks/:id' do
    it 'deletes a bookmark' do
      post '/bookmarks', { :url => 'google.com', :title => 'Google' }
      expect(last_response.status).to eq(201)
      bookmark_uri = last_response.body
      bookmark_id = bookmark_uri.split('/').last

      get "/bookmarks/#{bookmark_id}"
      expect(last_response.status).to be_ok

      delete "/bookmarks/#{bookmark_id}"
      expect(last_response.status).to be_ok

      get "/bookmarks/#{bookmark_id}"
      expect(last_response.status).to be_not_found
    end
  end

end
