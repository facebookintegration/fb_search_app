class FbSearchesController < ApplicationController
  def new
    @fb_search = FbSearch.new
  end

  def create
    @fb_search = FbSearch.find_or_create_by_keywords(params[:fb_search][:keywords])
    if @fb_search
      @fb_search.increment!(:frequency)
      redirect_to fb_search_path(@fb_search)
    else
      render 'new'
    end
  end

  def show
    @fb_search = FbSearch.find(params[:id])
  end

  def index
    @fb_searches = FbSearch.order("frequency DESC").all
  end

  def destroy
    FbSearch.find(params[:id]).destroy
    redirect_to fb_searches_path
  end
end
