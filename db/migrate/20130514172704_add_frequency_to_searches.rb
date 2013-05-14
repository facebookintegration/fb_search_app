class AddFrequencyToSearches < ActiveRecord::Migration
  def change
    add_column :fb_searches, :frequency, :integer, :default => 1
  end
end
