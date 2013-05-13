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

  def me()
    @conn.get("/me", @options).body
  end

  def profile_pic(username = nil)
    username ||= me.username
    @conn.get("/#{username}/picture?redirect=false", @options).body
  end

  def search(query, type)
    @conn.get("/search?q=#{query}&type=#{type}", @options).env
  end

  def extract_messages(search)
    result = ""
    search[:body]["data"].each do |post|
      result << "#{post["from"]["name"]} says: #{post["message"]}\n"
      result << "-" * 20 << "\n"
    end
    result
  end

  def extract_messages_html(search)
    html = "<ul>"
    search[:body]["data"].each do |post|
      html << "<li>#{post["from"]["name"]} says: #{post["message"]}</li>"
    end
    html << "</ul>"
  end
end
