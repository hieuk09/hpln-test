require "factory_girl"

FactoryGirl.define do
  factory :comment do |f|
    f.message "this is a comment"
  end
end
