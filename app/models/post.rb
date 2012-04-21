class Post < ActiveRecord::Base
  attr_accessible :date, :identifier, :link
  belongs_to :user
  belongs_to :application
  belongs_to :social_network
  has_and_belongs_to_many :links
  has_and_belongs_to_many :hashtags

  def self.from_facebook(identifier, user, application, link, created_time)
    post = SocialNetwork.facebook.posts.find_by_identifier(identifier)
    if post.nil?
      user = User.from_facebook(user.identifier)
      application = Application.from_facebook(application.identifier,
                                              application.name) rescue nil

      post = SocialNetwork.facebook.posts.create!(identifier:  identifier,
                                                  date:        created_time)

      Link.from_facebook(post, link)

      user.posts << post
      application.posts << post unless application.nil?
    end
    return post
  end

  def self.from_twitter(identifier, user, application, links, hashtags, created_time)
    post = SocialNetwork.twitter.posts.find_by_identifier(identifier)
    puts hashtags.size
    if post.nil?
      user = User.from_twitter(user)
      application = Application.from_twitter(application)

      post = SocialNetwork.twitter.posts.create!(identifier: identifier,
                                                 date:       created_time)

      Link.from_twitter(post, links)
      Hashtag.from_twitter(post, hashtags)

      user.posts << post
      application.posts << post
    end
    return post
  end
end
