require 'faraday'
require 'faraday_middleware'

class Connection
  def create(url)
    Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.response :mashify
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end

class FacebookWrapper
  def initialize(options = {})
    @conn = Connection.new.create("https://graph.facebook.com")
    @options = options
  end
end

class Me < FacebookWrapper
  def initialize(options = {})
    super(options)
  end

  def me
    @conn.get("/me", @options).body
  end
end

class Searcher < FacebookWrapper
  def intitialize(options = {})
    super(options)
  end

  def search(query, type)
    @conn.get("/search?q=#{query}&type=#{type}", @options).env
  end

  def search_data(query, type)
    search(query, type)[:body]["data"]
  end
end

class User < FacebookWrapper
  attr_reader :id, :name

  def initialize(id, name, options = {})
    super(options)
    @id = id
    @name = name
  end

  def profile_pic_url
    @conn.get("/#{id}/picture?redirect=false", @options).body["data"]["url"]
  end
end

class Post
  attr_reader :author, :message

  def initialize(post)
    @author = User.new(post["from"]["id"], post["from"]["name"])
    @message = post["message"]
  end
end
