FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| n }
    name { SecureRandom.uuid }
    sequence(:email) { |n| "#{name}#{n + 1}@twitter.com" }
    handle { name.to_s.slice(0, 15) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
