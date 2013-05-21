require 'spec_helper'

describe FbSearch do
  it "has a valid factory" do
    FactoryGirl.create(:fb_search).should be_valid
  end

  it "is valid with all correct search types" do
    FactoryGirl.create(:fb_search, :search_type => "post").should be_valid
    FactoryGirl.create(:fb_search, :search_type => "application").should be_valid
    FactoryGirl.create(:fb_search, :search_type => "page").should be_valid
    FactoryGirl.create(:fb_search, :search_type => "event").should be_valid
    FactoryGirl.create(:fb_search, :search_type => "user").should be_valid
    FactoryGirl.create(:fb_search, :search_type => "group").should be_valid
  end

  it "is invalid without keywords" do
    FactoryGirl.build(:fb_search, :keywords => nil).should_not be_valid
  end

  it "is invalid without a correct search type" do
    FactoryGirl.build(:fb_search, :search_type => "michael").should_not be_valid
  end
end
