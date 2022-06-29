# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    private # 85

    # 84, 85, 139, 151
    def current_user
      user = session[:user_id].present? ? user_from_session : user_from_token

      @current_user ||= user&.decorate
    end

    # 151
    def user_from_session
      User.find_by(id: session[:user_id])
    end

    # 151
    def user_from_token
      user = User.find_by(id: cookies.encrypted[:user_id])
      token = cookies.encrypted[:remember_token]

      return unless user&.remember_token_authenticated?(token)

      sign_in(user)
      user
    end

    # 85
    def user_signed_in?
      current_user.present?
    end

    # 111
    def require_authentication
      return if user_signed_in?

      flash[:warning] = 'You are not signed in!'
      redirect_to root_path
    end

    # 110
    def require_no_authentication
      return unless user_signed_in?

      flash[:warning] = 'You are already signed in!'
      redirect_to root_path
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    # 137
    def remember(user)
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token # 138
      cookies.encrypted.permanent[:user_id] = user.id # 138
    end

    def forget(user)
      user.forget_me
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end

    def sign_out
      forget(current_user) # 140
      session.delete(:user_id)
      @current_user = nil
    end

    helper_method :current_user, :user_signed_in? # 85
  end
  # rubocop:enable Metrics/BlockLength
end
