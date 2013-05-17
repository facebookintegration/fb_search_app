class FbSearchesController < ApplicationController
  def new
    @fb_search = FbSearch.new
  end

  def create
    @fb_search = FbSearch.find_or_create_by_keywords_and_type(params[:fb_search][:keywords], params[:fb_search][:type])
    @fb_search.keywords = @fb_search.keywords.strip || @fb_search.keywords
    if @fb_search.keywords != "" || @fb_search.save
      @fb_search.increment!(:frequency)
      redirect_to fb_search_path(@fb_search)
    else
      render 'new'
    end
  end

  def show
    @fb_search = FbSearch.find(params[:id])
    @other_attr = other_attr(@fb_search.type)
    search = FacebookApi::Search.new.data(@fb_search.keywords, @fb_search.type)
    @results = create_type_objs(search, @fb_search.type)
  end

  def index
    @fb_searches = FbSearch.order("frequency DESC").all
    flash[:type] = "post"
  end

  def destroy
    FbSearch.find(params[:id]).destroy
    redirect_to fb_searches_path
  end

  private

    def create_type_objs(search, type)
      case type
      when "post"
        search.map { |data| FacebookApi::Post.new(data) }
      when "user"
        #search.map { |data| FacebookApi::Person.new(data) }
      when "event"
        #search.map { |data| FacebookApi::Event.new(data) }
      when "application"
        search.map { |data| FacebookApi::Application.new(data) }
      when "group"
        search.map { |data| FacebookApi::Group.new(data) }
      else
        search.map { |data| FacebookApi::Page.new(data) }
      end
    end

    def other_attr(type)
      case type
      when "post"
        "user"
      when "user"
      when "event"
      when "application"
        "namespace"
      when "group"
        "version"
      else
        "category"
      end
    end
end
