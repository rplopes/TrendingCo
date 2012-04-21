class Hashtag < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :posts

  def self.from_twitter(post, names)
    return nil if names.nil?
    hashtags = []
    names.each do |name|
      hashtag = Hashtag.find_by_name(name["text"])
      if hashtag.nil?
        post.hashtags.create!(name: name["text"]) unless name["text"].nil?
      else
        post.hashtags << hashtag
      end
    end
    return hashtags
  end
end
