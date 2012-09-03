require 'spec_helper'
require 'factory_girl'

describe Post do
  let!(:post) { FactoryGirl.create(:post) }

  describe "should be valid" do
    it "with valid attribute" do
      post.should be_valid
    end
  end

  it { should validate_presence_of(:message) }
end
