FactoryGirl.define do
  factory :tweat do
    sequence(:id) { |n| n }
    content { SecureRandom.uuid }
    user_id { 1 }
  end
end
