require 'faker'

FactoryGirl.define do
  factory :fb_search do |f|
    f.keywords { Faker::Name.first_name }
    f.search_type "post"
  end

  factory :invalid_fb_search, :parent => :fb_search do |f|
    f.keywords nil
  end
end
