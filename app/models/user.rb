class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  EMAIL_MAX_LEN = Settings.model.email_max_len.to_i
  PWD_MIN_LEN = Settings.model.pwd_min_len.to_i
  NAME_MAX_LEN = Settings.model.name_max_len.to_i
  has_secure_password
  validates :email, presence: true, length: {maximum: EMAIL_MAX_LEN},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: PWD_MIN_LEN}
  validates :name, presence: true, length: {maximum: NAME_MAX_LEN}
  before_save{self.email = email.downcase}

  class << self
    def digest string
      cost = BCrypt::Engine.cost
      cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create(string, cost: cost)
    end
  end
end
