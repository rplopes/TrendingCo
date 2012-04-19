class Application < ActiveRecord::Base
  attr_accessible :identifier, :name
  has_many :posts

  def self.from_facebook(identifier, name)
    application = Application.find_by_identifier(identifier)
    if application.nil?
      application = Application.create!(identifier: identifier,
                                        name:       name)
    end
    return application
  end

  def self.from_twitter(name)
    application = Application.find_by_identifier(name)
    if application.nil?
      application = Application.create!(identifier: name,
                                        name:       name)
    end
    return application
  end
end
