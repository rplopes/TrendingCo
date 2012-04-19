class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :identifier
      t.integer :user_id
      t.string :link
      t.integer :application_id
      t.string :date

      t.timestamps
    end
  end
end
