class User < ApplicationRecord
  attr_accessor :old_password # 117

  has_secure_password validations: false # 78, 118

  validate :password_presence

  validate :correct_old_password, on: :update, if: -> { password.present? } # 129

  validates :password,
            confirmation: true,
            allow_blank: true,
            length: { minimum: 8, maximum: 70 }

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true # 78, 127

  validate :password_complexity # 119

  private

  def correct_old_password # 121
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password) # 124

    errors.add(:old_password, 'is incorrect')
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add(:password, 'Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character')
  end

  def password_presence # 120
    errors.add(:password, :blank) unless password_digest.present?
  end
end
