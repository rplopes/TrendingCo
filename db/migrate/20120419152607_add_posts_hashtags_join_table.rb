class AddPostsHashtagsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :hashtags_posts, :id => false do |t|
      t.integer :post_id
      t.integer :hashtag_id
    end
  end

  def self.down
    drop_table :hashtags_posts
  end
end
