require 'factory_girl'

FactoryGirl.define do
  factory :post do |f|
    f.message "this is a post"
  end
end
