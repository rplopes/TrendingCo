class FetcherController < ApplicationController
  def facebook
    @posts = fetch_facebook(params[:search], params[:day], params[:nextday])
    respond_to do |format|
      #format.html
      format.json{
        render json: @posts.to_json
      }
    end
  end

  private

    def fetch_facebook(query, day, nextday)
      return null if query.nil? or query == "" or day.nil? or day == "" or nextday.nil? or nextday == ""
      limit = 20
      counter = 0
      responses = []
      responses << FbGraph::Post.search(query, since: day, until: nextday, limit: limit)
      while responses.last.size >= limit do
        counter += 1
        responses << FbGraph::Post.search(query, since: day, until: nextday, limit: limit, offset: limit*counter)
      end
      users = {}
      posts = []
      responses.each do |response|
        response.each do |r|
        post = {}
          if users[r.from.identifier].nil?
            user = {}
            u = FbGraph::User.fetch(r.from.identifier).fetch
            user[:id]        = u.identifier
            user[:name]      = u.name
            user[:gender]    = u.gender
            user[:language]  = u.locale
            users[user[:id]] = user
          end
          application = {}
          unless r.application.nil?
            application[:id] = r.application.identifier
            application[:name] = r.application.name
          end

          post[:id]          = r.identifier
          post[:user]        = users[r.from.identifier]
          post[:message]     = r.message
          post[:link]        = r.link
          post[:application] = application
          post[:date]        = r.created_time

          posts << post
        end
      end
      return posts
    end
end
