class AddTypeToFbSearch < ActiveRecord::Migration
  def change
    add_column :fb_searches, :type, :string
  end
end
