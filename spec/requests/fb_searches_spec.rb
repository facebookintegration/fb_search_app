require 'spec_helper'

describe "FbSearches" do
  before { @fb_search = FbSearch.create(:keywords => "llama") }

  describe "going to home page" do
    before { visit root_path }

    it "should have the correct title" do
      page.should have_selector('h1', :content => 'Facebook Search')
    end

    it "should have the correct form elements" do
      page.should have_selector('input', :type => 'text')
      page.should have_selector('input', :type => 'submit')
    end

    it "should have the correct links" do
      page.should have_link('View recent searches', :href => fb_searches_path)
    end

    describe "submitting a new search" do
      it "should not accept a blank search" do
        fill_in :keywords, :with => " "
        expect { click_button "Search" }.not_to change(FbSearch, :count)
        page.should have_selector('h1', :content => 'Facebook Search')
      end

      it "should not add a repeated search to the database" do
        fill_in :keywords, :with => @fb_search.keywords
        expect { click_button "Search" }.not_to change(FbSearch, :count)
        current_path.should == fb_search_path(@fb_search)
      end

      it "should increment frequency of a repeated search" do
        fill_in :keywords, :with => @fb_search.keywords
        expect { click_button "Search" }.to change(@fb_search, :frequency).by(1)
      end

      it "should accept a valid search" do
        fill_in :keywords, :with => "squirrels"
        expect { click_button "Search" }.to change(FbSearch, :count).by(1)
        page.should have_selector('h1', :content => "Search Results: squirrels")
      end
    end
  end

  describe "going to search results page" do
    before { visit fb_search_path(@fb_search) }
    it "should have the correct links" do
      page.should have_link('Back to new search', :href => root_path)
    end
  end

  describe "going to recent searches" do
    before { visit fb_searches_path }

    it "should have a list of links to recent searches" do
      page.should have_link('llama', :href => fb_search_path(@fb_search));
    end

    it "should have the correct heading" do
      page.should have_selector('h1', :content => 'Recent Searches')
    end

    it "should have a link back to new search" do
      page.should have_link('Back to new search', :href => new_fb_search_path)
    end

    it "should provide a working delete link" do
      page.should have_link('remove', :href => fb_search_path(@fb_search))
      expect { click_link 'remove' }.to change(FbSearch, :count).by(-1)
      current_path.should == fb_searches_path
    end

    it "should list the frequency of each search" do
      page.should have_content("(#{@fb_search.frequency})")
    end
  end
end
