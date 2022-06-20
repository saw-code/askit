class ApplicationController < ActionController::Base
  include ErrorHandling

  private # 85

  def current_user # 84, 85
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present?
  end

  def user_signed_in? # 85
    current_user.present?
  end

  helper_method :current_user, :user_signed_in? # 85
end
