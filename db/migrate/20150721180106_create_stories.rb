class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.text :title
      t.text :summary
      t.integer :user_id
    end
  end
end
