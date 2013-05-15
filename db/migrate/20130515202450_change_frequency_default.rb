class ChangeFrequencyDefault < ActiveRecord::Migration
  def up
    change_column :fb_searches, :frequency, :integer, :default => 0
  end

  def down
  end
end
