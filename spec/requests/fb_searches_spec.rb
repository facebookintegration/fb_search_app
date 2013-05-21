require 'spec_helper'

describe "FbSearches" do
  before do
    @search_post = FactoryGirl.create(:fb_search, :keywords => "llama", :search_type => "post")
    @search_group = FactoryGirl.create(:fb_search, :keywords => "llama", :search_type => "group")
    @search_page = FactoryGirl.create(:fb_search, :keywords => "llama", :search_type => "page")
  end

  describe "going to home page" do
    before { visit root_path }

    it "should have the correct title" do
      page.should have_selector('h1', :text => 'Facebook Search')
    end

    it "should have the correct form elements" do
      page.should have_selector('input', :type => 'text')
      page.should have_selector('select')
      page.should have_selector('input', :type => 'submit')
    end

    it "should have the correct links" do
      page.should have_link('View recent searches', :href => fb_searches_path)
    end

    describe "submitting a new search" do
      it "should not accept a blank search" do
        fill_in :keywords, :with => ""
        expect { click_button "Search" }.not_to change(FbSearch, :count)
        page.should have_selector('h1', :content => 'Facebook Search')
      end

      it "should accept a valid search" do
        VCR.use_cassette('Cassette4') do
          fill_in :keywords, :with => "squirrels"
          expect { click_button "Search" }.to change(FbSearch, :count).by(1)
          page.should have_selector('h1', :content => "Search Results: squirrels")
        end
      end
    end
  end

  describe "going to search results page" do
    it "should have the correct links" do
      VCR.use_cassette('Cassette2') do
        visit fb_search_path(@search_page)
        page.should have_link('Back to new search', :href => root_path)
      end
    end

    it "should render the group results correctly" do
      VCR.use_cassette('Cassette7') do
        visit fb_search_path(@search_group)
        page.should have_content('Group')
      end
    end
  end

  describe "going to recent searches" do
    before { visit fb_searches_path }

    it "should have a list of links to recent searches" do
      page.should have_link('llama', :href => fb_search_path(@search_post));
    end

    it "should have the correct heading" do
      page.should have_selector('h1', :content => 'Recent Searches')
    end

    it "should have a link back to new search" do
      page.should have_link('Back to new search', :href => new_fb_search_path)
    end

    it "should provide a working delete link" do
      page.should have_link('remove', :href => fb_search_path(@search_post))
      expect { click_link 'remove' }.to change(FbSearch, :count).by(-1)
      current_path.should == fb_searches_path
    end
  end
end
