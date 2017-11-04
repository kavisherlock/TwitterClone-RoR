# == Schema Information
#
# Table name: relationships
#
#  id                   :integer          not null, primary key
#  follower_id          :integer
#  followee_id          :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  validates :follower_id, presence: true
  validates :followee_id, presence: true
end
