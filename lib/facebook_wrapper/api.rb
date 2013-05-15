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

  def info
    @conn.get("/me", @options).body
  end
end

class Picture < FacebookWrapper
  attr_reader :url

  def initialize(id, width = 50, height = 50, url = nil, options = {})
    super(options)
    @url = url || @conn.get("/#{id}/picture?redirect=false&width=#{width}&height=#{height}", @options).body["data"]["url"]
  end
end

class Search < FacebookWrapper
  attr_accessor :type

  def initialize(type, options = {})
    super(options)
    @type = type
  end

  def data(query)
    find(query)[:body]["data"]
  end

  def find(query)
    @conn.get("/search?q=#{query}&type=#{@type}", @options).env
  end
end

class FacebookObject
  attr_reader :id, :name

  def initialize(info)
    @id = info["id"]
    @name = info["name"]
  end

  def picture(width = 50, height = 50)
    Picture.new(@id, width, height)
  end
end

class Application < FacebookObject

end

class Event < FacebookObject

end

class Group < FacebookObject

end

class Page < FacebookObject

end

class Person < FacebookObject

end

class Post < FacebookObject
  attr_reader :author, :message

  def initialize(post)
    super("id" => post["id"], "name" => post["name"])
    @author = Person.new(post["from"])
    @message = post["message"]
    @picture_url = post["picture"]
  end

  def picture
    @picture_url ? Picture.new("", nil, nil, @picture_url) : nil
  end
end
