# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :old_password, :remember_token # 117, 134

  has_secure_password validations: false # 78, 118

  validate :password_presence

  validate :correct_old_password, on: :update, if: -> { password.present? } # 129

  validates :password,
            confirmation: true,
            allow_blank: true,
            length: { minimum: 8, maximum: 70 }

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true # 78, 127

  validate :password_complexity # 119

  # 133, 134
  def remember_me
    self.remember_token = SecureRandom.urlsafe_base64 # 135
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, digest(remember_token)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def forget_me
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, nil
    # rubocop:enable Rails/SkipsModelValidations
    self.remember_token = nil # 140
  end

  # 134
  def remember_token_authenticated?(remember_token)
    return false if remember_token_digest.blank? # 140

    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
  end

  private

  # 134
  def digest(string)
    cost = if ActiveModel::SecurePassword
              .min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # 121
  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password) # 124

    errors.add(:old_password, 'is incorrect')
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    msg = 'Complexity requirement not met. Length should be 8-70 characters and ' \
          'include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    errors.add(:password, msg)
  end

  # 120
  def password_presence
    errors.add(:password, :blank) if password_digest.blank?
  end
end
