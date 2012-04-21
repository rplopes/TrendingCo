class Link < ActiveRecord::Base
  attr_accessible :url
  has_and_belongs_to_many :posts

  def self.from_facebook(post, url)
    return nil if url.nil?
    link = Link.find_by_url(url)
    if link.nil?
      post.links.create!(url: url) unless url.nil?
    else
      post.links.add(link)
    end
  end

  def self.from_twitter(post, urls)
    return nil if urls.nil?
    links = []
    urls.each do |url|
      link = Link.find_by_url(url["expanded_url"])
      if link.nil?
        post.links.create!(url: url["expanded_url"]) unless url["expanded_url"].nil?
      else
        post.links << link
      end
    end
    return links
  end
end
