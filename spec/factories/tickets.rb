require 'ffaker'

FactoryGirl.define do
  factory :ticket do
    status :pending
    description { FFaker::Lorem.sentence }
    customer

    trait :with_agent do
      after(:build) { |t| t.agent = create(:agent, :confirmed) }
    end
  end
end
