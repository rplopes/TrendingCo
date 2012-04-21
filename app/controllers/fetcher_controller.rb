class FetcherController < ApplicationController

  def default
  end

  def facebook
    @posts = fetch_facebook(params[:search], params[:from], params[:to])
    render json: @posts.to_json
  end

  def twitter
    @posts = fetch_twitter(params[:search], params[:from], params[:to])
    render json: @posts.to_json
  end

  private

    def fetch_facebook(query, from, to)
      return null if query.nil? or query == "" or from.nil? or from == "" or to.nil? or to == ""
      limit = 5000
      counter = 0
      responses = []
      while responses.size == 0 or responses.last.size > 0 do
        responses << FbGraph::Post.search(query, since: from, until: to, limit: limit, offset: limit*counter)
        counter += 1
      end
      posts = []
      responses.each do |response|
        response.each do |r|

          post = Post.from_facebook(r.identifier,
                                    r.from,
                                    r.application,
                                    r.link,
                                    r.created_time)

          application = {id: post.application.identifier, name: post.application.name} rescue nil

          posts << {social_network: post.social_network.name,
                    id:             post.identifier,
                    links:          post.links,
                    date:           post.date,
                    application:    application,
                    user:           {
                                      id: post.user.identifier,
                                      name: post.user.name,
                                      gender: post.user.gender,
                                      language: post.user.language
                                    },
                    message:        r.message}
        end
      end
      return posts
    end

    def fetch_twitter(query, from, to)
      return null if query.nil? or query == "" or from.nil? or from == "" or to.nil? or to == ""
      limit = 100
      page = 1
      responses = []
      begin
        while responses.size == 0 or responses.last.size > 0 do
          responses << Twitter.search(query, until: to, rpp: limit, page: page, include_entities: true)
          page += 100
        end
      rescue
      end
      posts = []
      responses.each do |response|
        response.each do |r|

          post = Post.from_twitter(r.id,
                                   r[:from_user],
                                   r.source,
                                   r.urls,
                                   r.hashtags,
                                   r.created_at)

          application = {id: post.application.identifier, name: post.application.name} rescue nil

          posts << {social_network: post.social_network.name,
                    id:             post.identifier,
                    links:          post.links,
                    hashtags:       post.hashtags,
                    date:           post.date,
                    application:    application,
                    user:           {
                                      id: post.user.identifier,
                                      name: post.user.name,
                                      gender: nil,
                                      language: post.user.language
                                    },
                    message:        r[:text]}
        end
      end
      return posts
    end
end