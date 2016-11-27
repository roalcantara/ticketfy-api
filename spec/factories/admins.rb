require 'ffaker'

FactoryGirl.define do
  factory :admin do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    password_confirmation { password }
  end
end
