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

module FacebookApi
  TYPES = %w(post group event user application page)

  class FacebookObject
    attr_reader :id, :name

    def initialize(info)
      @id = info["id"]
      @name = info["name"]
    end

    def picture(options = {})
      Picture.new("id" => @id, "name" => "Picture for " << (@name || "post"))
    end
  end

  class Application < FacebookObject
    attr_reader :namespace

    def initialize(info)
      super(info)
      @namespace = info["namespace"]
    end
  end

  class Event < FacebookObject

  end

  class FacebookWrapper
    def initialize
      @conn = Connection.new.create("https://graph.facebook.com")
    end

    def get(request, options = {})
      @conn.get("/#{request}", options)
    end
  end

  class Group < FacebookObject
    attr_reader :version

    def initialize(info)
      super(info)
      @version = info["version"]
    end
  end

  class Page < FacebookObject
    attr_reader :category

    def initialize(info)
      super(info)
      @category = info["category"]
    end
  end

  class Person < FacebookObject

  end

  class Picture < FacebookObject
    def get(options = {})
      options["redirect"] = "false"
      FacebookWrapper.new.get("#{@id}/picture", options).body["data"]["url"]
    end

    def picture(options)
      get(options)
    end
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
      @picture_url ? PostPicture.new("id" => @id, "name" => "Picture for " << (@name || "post"), "url" => @picture_url) : nil
    end
  end

  class PostPicture < FacebookObject
    def initialize(info)
      super("id" => info["id"], "name" => info["name"])
      @picture_url = info["url"]
    end

    def get
      @picture_url
    end

    def picture
      get
    end
  end

  class Search
    def data(query, type)
      find("q" => query, "type" => type)[:body]["data"]
    end

    def find(options = {})
      FacebookWrapper.new.get("search", options).env
    end
  end
end
