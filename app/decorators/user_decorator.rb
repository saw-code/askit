# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  # 91
  def name_or_email
    return name if name.present?

    email.split('@')[0]
  end
end
