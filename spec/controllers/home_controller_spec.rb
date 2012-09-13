require 'spec_helper'

describe HomeController do
  describe "GET '/' " do
    it "should be successfull" do
      get :index
      response.should be_success
    end
  end

  describe "POST '/'" do
    it "should redirect to GET '\'" do
      post :home
      response.should redirect_to("/")
    end
  end
end
