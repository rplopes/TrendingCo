class Application < ActiveRecord::Base
  attr_accessible :identifier, :name
  has_many :posts

  def self.get_or_create(identifier, name)
    application = Application.find_by_identifier(identifier)
    if application.nil?
      application = Application.create!(identifier: identifier,
                                        name:       name)
    end
    return application
  end
end
