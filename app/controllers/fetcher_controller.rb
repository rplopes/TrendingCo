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

  def twitter
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
      limit = 5000
      counter = 0
      responses = []
      while responses.size == 0 or responses.last.size > 0 do
        responses << FbGraph::Post.search(query, since: day, until: nextday, limit: limit, offset: limit*counter)
        counter += 1
      end
      posts = []
      responses.each do |response|
        response.each do |r|

          post = Post.get_or_create(r.identifier,
                                    r.from,
                                    r.application,
                                    r.link,
                                    r.created_time)

          application = {id: post.application.identifier, name: post.application.name} rescue nil

          posts << {id:          post.identifier,
                    link:        post.link,
                    date:        post.date,
                    application: application,
                    user:        {
                                   id: post.user.identifier,
                                   name: post.user.name,
                                   gender: post.user.gender,
                                   language: post.user.language
                                 },
                    message:     r.message}
        end
      end
      return posts
    end
end