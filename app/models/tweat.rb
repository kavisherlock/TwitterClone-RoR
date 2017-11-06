# == Schema Information
#
# Table name: relationships
#
#  id                   :integer          not null, primary key
#  content              :string
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Tweat < ApplicationRecord
  belongs_to :user

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
