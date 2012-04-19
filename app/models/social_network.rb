class SocialNetwork < ActiveRecord::Base
  attr_accessible :name
  has_many :posts

  def self.facebook
    SocialNetwork.create!(name: "Facebook") unless SocialNetwork.find_by_name("Facebook")
    return SocialNetwork.find_by_name("Facebook")
  end

  def self.twitter
    SocialNetwork.create!(name: "Twitter") unless SocialNetwork.find_by_name("Twitter")
    return SocialNetwork.find_by_name("Twitter")
  end
end
