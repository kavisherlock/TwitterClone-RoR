FactoryGirl.define do
  factory :user do
    name { SecureRandom.uuid }
    sequence(:email) { |n| "#{first_name}.#{last_name}#{n + 1}@twitter.com" }
    handle { "#{first_name}#{last_name}" }
  end
end
