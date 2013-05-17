class FbSearchesController < ApplicationController
  def new
    @fb_search = FbSearch.new
  end

  def create
    @fb_search = FbSearch.find_or_create_by_keywords(params[:fb_search][:keywords])
    @fb_search.keywords = @fb_search.keywords.strip || @fb_search.keywords
    flash[:type] = params[:type][:option]
    if @fb_search.keywords != "" || @fb_search.save
      @fb_search.increment!(:frequency)
      redirect_to fb_search_path(@fb_search)
    else
      render 'new'
    end
  end

  def show
    @fb_search = FbSearch.find(params[:id])
    @type = flash[:type]
    flash[:type] = @type
    search = FacebookApi::Search.new.data(@fb_search.keywords, @type)
    @results = create_type_objs(search, @type)
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
end
