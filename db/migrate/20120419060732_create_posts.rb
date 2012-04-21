class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :identifier
      t.string :date
      t.integer :user_id
      t.integer :application_id
      t.integer :social_network_id

      t.timestamps
    end
  end
end
