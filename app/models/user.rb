# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  name                 :string
#  email                :string
#  handle               :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 127 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false,
                                  message: 'duplicate email' }

  validates :handle, presence: true,
                     length: { maximum: 15 },
                     uniqueness: { case_sensitive: false,
                                   message: 'duplicate handle' }

  has_secure_password
  validates :password, length: { minimum: 6 }
end
