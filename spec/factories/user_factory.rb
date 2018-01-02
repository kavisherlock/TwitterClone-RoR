FactoryGirl.define do
  factory :user do
    sequence(:id) { 1 }
    name { SecureRandom.uuid }
    sequence(:email) { |n| "#{name}#{n + 1}@dwidder.com" }
    handle { name.to_s.slice(0, 15) }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end

  factory :user2, class: User do
    sequence(:id) { 2 }
    name { SecureRandom.uuid }
    sequence(:email) { |n| "#{name}#{n + 1}@dwidder.com" }
    handle { name.to_s.slice(0, 15) }
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }
  end
end
