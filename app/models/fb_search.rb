class FbSearch < ActiveRecord::Base
  attr_accessible :keywords, :search_type

  validates :keywords, :presence => true
  validates :search_type, :inclusion => { :in => FacebookApi::TYPES }
end
