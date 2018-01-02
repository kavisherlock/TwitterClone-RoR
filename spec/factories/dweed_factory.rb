FactoryGirl.define do
  factory :dweed do
    id { 1 }
    content { SecureRandom.uuid }
    user_id { 1 }
  end
end
