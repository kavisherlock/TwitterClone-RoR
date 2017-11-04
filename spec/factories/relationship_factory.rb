FactoryGirl.define do
  factory :relationship do
    follower { FactoryGirl.create(:user) }
    followee { FactoryGirl.create(:user2) }
    follower_id { follower.id }
    followee_id { followee.id }
  end
end
