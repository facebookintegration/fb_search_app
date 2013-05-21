require 'spec_helper'

describe FbSearchesController do
  describe "GET #new" do
    it "assigns a new search to @fb_search"

    it "renders the :new template" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new search in the database" do
        expect { post :create, :fb_search => FactoryGirl.attributes_for(:fb_search) }.to change(FbSearch, :count).by(1)
      end

      it "redirects to the home page" do
        post :create, :fb_search => FactoryGirl.attributes_for(:fb_search)
        response.should redirect_to FbSearch.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new search in the database" do
        expect { post :create, :fb_search => FactoryGirl.attributes_for(:invalid_fb_search) }.to_not change(FbSearch, :count)
      end

      it "re-renders the :new template" do
        post :create, :fb_search => FactoryGirl.attributes_for(:invalid_fb_search)
        response.should render_template :new
      end
    end

    context "with a repeated search" do
      it "does not add a new entry to the database" do
        @search = FactoryGirl.create(:fb_search, :keywords => 'dinosaur')
        expect { post :create, :fb_search => FactoryGirl.attributes_for(:fb_search, :keywords => 'dinosaur') }.to_not change(FbSearch, :count)
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested search to @fb_search" do
      VCR.use_cassette('Cassette5') do
        search = FactoryGirl.create(:fb_search, :keywords => 'Michael')
        get :show, :id => search
        assigns(:fb_search).should eq(search)
      end
    end

    it "renders the :show template" do
      VCR.use_cassette('Cassette6') do
        get :show, :id => FactoryGirl.create(:fb_search, :keywords => 'Michael')
        response.should render_template :show
      end
    end
  end

  describe "GET #index" do
    it "populates an array of searches" do
      search = FactoryGirl.create(:fb_search)
      get :index
      assigns(:fb_searches).should eq([search])
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end

  describe "DELETE #destroy" do
    before { @search = FactoryGirl.create(:fb_search) }

    it "removes a search from the database" do
      expect { delete :destroy, :id => @search }.to change(FbSearch, :count).by(-1)
    end

    it "renders the :index view" do
      delete :destroy, :id => @search
      response.should redirect_to fb_searches_url
    end
  end
end
