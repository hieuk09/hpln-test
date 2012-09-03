require 'spec_helper'
require 'factory_girl'

describe Comment do
  let!(:comment) { FactoryGirl.create(:comment) }

  describe "should be valid" do
    it "with valid attributes" do
      comment.should be_valid
    end
  end

  it { should validate_presence_of(:message) }
end
