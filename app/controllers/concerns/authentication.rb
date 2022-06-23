module Authentication
  extend ActiveSupport::Concern

  included do
    private # 85

    def current_user # 84, 85
      @current_user ||= User.find_by(id: session[:user_id]).decorate if session[:user_id].present? # 91 decorate
    end

    def user_signed_in? # 85
      current_user.present?
    end

    def require_authentication # 111
      return if user_signed_in?

      flash[:warning] = 'You are not signed in!'
      redirect_to root_path
    end

    def require_no_authentication # 110
      return if !user_signed_in?

      flash[:warning] = 'You are already signed in!'
      redirect_to root_path
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out
      session.delete(:user_id)
    end

    helper_method :current_user, :user_signed_in? # 85
  end
end
