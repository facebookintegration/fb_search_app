class FbSearchesController < ApplicationController
  def new
    @fb_search = FbSearch.new
  end

  def create
    @fb_search = FbSearch.new(params[:fb_search])
    if @fb_search.save
      redirect_to fb_search_path(@fb_search)
    else
      render 'new'
    end
  end

  def show
    @fb_search = FbSearch.find(params[:id])
  end
end
