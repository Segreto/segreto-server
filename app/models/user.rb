class User < ActiveRecord::Base
  before_save { self.username = username.downcase }
  validates :username,
    presence: true,
    length: { maximum: 24 },
    uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :name, length: { maximum: 100 }
  validates :password, length: { minimum: 8 }

  has_secure_password
end
