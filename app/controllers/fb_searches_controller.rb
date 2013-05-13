class FbSearchesController < ApplicationController
  def new
    @fb_search = FbSearch.new
  end
end
