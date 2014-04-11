class User < ActiveRecord::Base
  before_save { self.username = username.downcase }
  validates :username,
    presence: true,
    length: { maximum: 24 },
    uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX, allow_blank: true }
  validates :name, length: { maximum: 100 }
  validates :password, on: :create,
                       confirmation: true,
                       length: { minimum: 8 }
  validates :password_confirmation, on: :create,
                                    length: { minimum: 8 }

  has_secure_password

  def create_token
    self.update(remember_token: SecureRandom.urlsafe_base64)
  end

  def as_json options={}
    super options.merge(root: true,
                        only: [:username, :email, :name, :remember_token])
  end
end
