require 'sinatra'
require 'data_mapper'
require 'dm-serializer'
require_relative 'bookmark'

::DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bookmarks.db")
::DataMapper.finalize.auto_upgrade!

class Hash
  def slice(*whitelist)
    whitelist.inject({}) do |result, key|
      result.merge(key => self[key])
    end
  end
end

def get_all_bookmarks
  ::Bookmark.all(:order => :title)
end

get '/bookmarks' do
  content_type :json
  get_all_bookmarks.to_json
end

get '/bookmarks/:id' do |bookmark_id|
  bookmark = ::Bookmark.get(bookmark_id)

  if bookmark
    content_type :json
    bookmark.to_json
  else
    404
  end
end

post '/bookmarks' do
  input = params.slice('url', 'title')
  bookmark = ::Bookmark.new(input)
  if bookmark.save
    [ 201, "/bookmarks/#{bookmark['id']}" ]
  else
    400
  end
end

put '/bookmarks/:id' do |bookmark_id|
  input = params.slice('url', 'title')
  bookmark = ::Bookmark.get(bookmark_id)

  if bookmark
    if bookmark.update(input)
      204
    else
      400
    end
  else
    404
  end
end

delete '/bookmarks/:id' do |bookmark_id|
  bookmark = ::Bookmark.get(bookmark_id)

  if bookmark
    if bookmark.destroy
      200
    else
      400
    end
  else
    404
  end
end

