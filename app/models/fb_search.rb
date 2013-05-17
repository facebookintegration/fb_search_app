class FbSearch < ActiveRecord::Base
  attr_accessible :keywords, :type

  validates :keywords, :presence => true
end
