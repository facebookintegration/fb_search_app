class FbSearch < ActiveRecord::Base
  attr_accessible :keywords

  validates :keywords, :presence => true
end
