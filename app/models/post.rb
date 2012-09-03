class Post < ActiveRecord::Base
  has_many :comment
  attr_accessible :message
  validates :message, presence: true
end
