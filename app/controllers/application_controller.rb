require 'koala'
require 'sinatra'

class ApplicationController < ActionController::Base
  protect_from_forgery
  enable :sessions
  set :raise_errors, false
  set :show_exceptions, false

  FACEBOOK_SCOPE = 'user_likes,user_photos,user_photo_video_tags, user_videos, user_status, user_notes'
  
  unless ENV["FACEBOOK_APP_ID"] && ENV["FACEBOOK_SECRET"]
    abort("missing env vars: please set FACEBOOK_APP_ID and FACEBOOK_SECRET with your app credentials")
  end

  before do
    # HTTPS redirect
    if settings.environment == :production && request.scheme != 'https'
      redirect "https://#{request.env['HTTP_HOST']}"
    end
  end

  # the facebook session expired! reset ours and restart the process
  error(Koala::Facebook::APIError) do
    session[:access_token] = nil
    redirect "/auth/facebook"
  end

  get "/" do
    # Get base API Connection
    @graph  = Koala::Facebook::API.new(session[:access_token])

    # Get public details of current application
    @app  =  @graph.get_object(ENV["FACEBOOK_APP_ID"])
    if session[:access_token]
      @user    = @graph.get_object("me")
      @post    = @graph.get_connections("me", "statuses")
    end

    erb :index
  end

  # used by Canvas apps - redirect the POST to be a regular GET
  post "/" do
    redirect "/"
  end

  # used to close the browser window opened to post to wall/send to friends
  get "/close" do
    "<body onload='window.close();'/>"
  end

  get "/sign_out" do
    session[:access_token] = nil
    redirect '/'
  end

  get "/auth/facebook" do
    session[:access_token] = nil
    redirect authenticator.url_for_oauth_code(:permissions => FACEBOOK_SCOPE)
  end

  get '/auth/facebook/callback' do
    session[:access_token] = authenticator.get_access_token(params[:code])
    redirect '/'
  end

end
