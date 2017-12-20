class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  EMAIL_MAX_LEN = Settings.model.email_max_len.to_i
  PWD_MIN_LEN = Settings.model.pwd_min_len.to_i
  NAME_MAX_LEN = Settings.model.name_max_len.to_i
  attr_accessor :remember_token
  has_secure_password
  validates :email, presence: true, length: {maximum: EMAIL_MAX_LEN},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: PWD_MIN_LEN}, allow_nil: true
  validates :name, presence: true, length: {maximum: NAME_MAX_LEN}
  before_save{self.email = email.downcase}

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def remember
    self.remember_token = User.new_token
    update_attributes(remember_digest: User.digest(remember_token))
  end

  def forget
    update_attributes(remember_digest: nil)
  end

  class << self
    def digest string
      cost = BCrypt::Engine.cost
      cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
