require 'ffaker'

FactoryGirl.define do
  factory :customer do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    password_confirmation { password }

    trait :confirmed do
      before(:create) { |agent| agent.confirmed_at = Date.current }
    end
  end
end
