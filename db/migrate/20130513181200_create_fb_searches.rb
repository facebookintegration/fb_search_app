class CreateFbSearches < ActiveRecord::Migration
  def change
    create_table :fb_searches do |t|
      t.string :keywords

      t.timestamps
    end
  end
end
