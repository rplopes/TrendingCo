class User < ActiveRecord::Base
  attr_accessible :gender, :identifier, :language, :name
  has_many :posts

  def self.get_or_create(identifier)
    user = User.find_by_identifier(identifier)
    if user.nil?
      u = FbGraph::User.fetch(identifier).fetch
      user = User.create!(identifier: identifier,
                          name:       u.name,
                          gender:     u.gender,
                          language:   u.locale)
    end
    return user
  end
end
