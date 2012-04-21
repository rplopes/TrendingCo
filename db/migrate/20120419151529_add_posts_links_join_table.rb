class AddPostsLinksJoinTable < ActiveRecord::Migration
  def self.up
    create_table :links_posts, :id => false do |t|
      t.integer :post_id
      t.integer :link_id
    end
  end

  def self.down
    drop_table :links_posts
  end
end