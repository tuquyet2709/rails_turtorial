class User < ApplicationRecord
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
            length: {maximum: Settings.maximum.max_email_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :name, presence: true,
            length: {maximum: Settings.maximum.max_name_length}
  validates :password, presence: true,
            length: {minimum: Settings.minimum.min_password_length}
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
