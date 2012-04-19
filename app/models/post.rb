class Post < ActiveRecord::Base
  attr_accessible :date, :identifier, :link
  belongs_to :user
  belongs_to :application
  belongs_to :social_network

  def self.from_facebook(identifier, user, application, link, created_time)
    post = SocialNetwork.facebook.posts.find_by_identifier(identifier)
    if post.nil?
      user = User.from_facebook(user.identifier)
      application = Application.from_facebook(application.identifier,
                                              application.name) rescue nil

      post = SocialNetwork.facebook.posts.create!(identifier:  identifier,
                                                  link:        link,
                                                  date:        created_time)

      user.posts << post
      application.posts << post unless application.nil?
    end
    return post
  end

  def self.from_twitter(identifier, user, application, links, created_time)
    post = SocialNetwork.twitter.posts.find_by_identifier(identifier)
    if post.nil?
      user = User.from_twitter(user)
      application = Application.from_twitter(application)
      link = links.first rescue nil
      post = SocialNetwork.twitter.posts.create!(identifier: identifier,
                                                 link:       link,
                                                 date:       created_time)

      user.posts << post
      application.posts << post
    end
    return post
  end
end
