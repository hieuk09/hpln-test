class HomeController < ApplicationController
  FACEBOOK_SCOPE = 'user_likes,user_photos,user_photo_video_tags, user_videos, user_status, user_notes, user_birthday'

  RESULT = {
    "1" => "http://www.facebook.com/note.php?note_id=297062146993313",
    "2" => "http://www.facebook.com/note.php?note_id=297061876993340",
    "3" => "http://www.facebook.com/note.php?note_id=297061500326711",
    "4" => "http://www.facebook.com/note.php?note_id=297061316993396",
    "5" => "http://www.facebook.com/note.php?note_id=297061183660076",
    "6" => "http://www.facebook.com/note.php?note_id=297060996993428",
    "7" => "http://www.facebook.com/note.php?note_id=297060833660111",
    "8" => "http://www.facebook.com/note.php?note_id=297060640326797",
    "9" => "http://www.facebook.com/note.php?note_id=297060426993485",
    "11" => "http://www.facebook.com/note.php?note_id=297060136993514",
    "22" => "http://www.facebook.com/note.php?note_id=297059700326891",
  }

  # get "/" do
  def index
    # Get base API Connection
    @graph  = Koala::Facebook::API.new(session[:access_token])

    # Get public details of current application
    @app  =  @graph.get_object(ENV["FACEBOOK_APP_ID"])
    if session[:access_token]
      @user    = @graph.get_object("me")
      @status    = @graph.get_connections("me", "statuses")
    end

    @status.each do |status|
      #post = Post.create(message: status["message"])
      data = status["comments"]

      if data then
        data = data["data"]

        data.each do |d|
          #comment = Comment.create(message: d["message"], post_id: post.id)
          #comment.save
        end
      end

    end

    id = @user["id"]
    @id = sum_digit(id.to_i)

    @link = RESULT[@id.to_s]

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # used by Canvas apps - redirect the POST to be a regular GET
  # post "/" do
  def home
    redirect_to action: :index
  end

  # used to close the browser window opened to post to wall/send to friends
  # get "/close" do
  def close
    "<body onload='window.close();'/>"
  end

  # get "/sign_out" do
  def sign_out
    session[:access_token] = nil
    redirect_to '/'
  end

  # get "/auth/facebook" do
  def authenticate
    session[:access_token] = nil
    redirect_to authenticator.url_for_oauth_code(:permissions => FACEBOOK_SCOPE)
  end

  # get '/auth/facebook/callback' do
  def callback
    session[:access_token] = authenticator.get_access_token(params[:code])
    redirect_to '/'
  end

  private

  def host
    request.env['HTTP_HOST']
  end 

  def scheme
    request.scheme
  end 

  def url_no_scheme(path = '')
    "//#{host}#{path}"
  end 

  def url(path = '')
    "#{scheme}://#{host}#{path}"
  end 

  def authenticator
     @authenticator ||= Koala::Facebook::OAuth.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_SECRET"], url("/auth/facebook/callback"))
  end

  def sum_digit(number)
    sum = 0
    while sum == 0 || (sum > 10 && sum != 11 && sum != 22)
      sum = 0
      while number > 0
        sum += number % 10
        number /= 10
      end

      number = sum
    end
    sum
  end
end
