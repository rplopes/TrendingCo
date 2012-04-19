class Post < ActiveRecord::Base
  attr_accessible :date, :identifier, :link
  belongs_to :user
  belongs_to :application

  def self.get_or_create(identifier, user, application, link, created_time)
    post = Post.find_by_identifier(identifier)
    if post.nil?
      user = User.get_or_create(user.identifier)
      application = Application.get_or_create(application.identifier,
                                              application.name) rescue nil

      post = Post.create!(identifier:  identifier,
                          link:        link,
                          date:        created_time)

      user.posts << post
      application.posts << post unless application.nil?
    end
    return post
  end
end
