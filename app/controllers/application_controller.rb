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

end
