class AddSearchTypeToSearch < ActiveRecord::Migration
  def change
    add_column :fb_searches, :search_type, :string
  end
end
