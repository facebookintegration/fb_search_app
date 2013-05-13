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
  end
end
