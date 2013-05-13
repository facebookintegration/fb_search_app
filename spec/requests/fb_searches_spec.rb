require 'spec_helper'

describe "FbSearches" do
  describe "going to home page" do
    before { visit root_path }

    it "should have the correct title" do
      page.should have_selector('h1', :content => 'FB Post Search')
    end

    it "should have the correct form elements" do
      page.should have_selector('input', :type => 'text')
      page.should have_selector('input', :type => 'submit')
    end

    describe "submitting a new search" do
      it "should not accept a blank search" do
        fill_in :keywords, :with => " "
        expect { click_button "Search" }.not_to change(FbSearch, :count)
        page.should have_selector('h1', :content => 'FB Post Search')
      end

      it "should accept a valid search" do
        fill_in :keywords, :with => "squirrels"
        expect { click_button "Search" }.to change(FbSearch, :count).by(1)
        page.should have_selector('h1', :content => "Search Results: squirrels")
      end
    end
  end
end
