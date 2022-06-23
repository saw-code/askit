class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: :destroy # 111

  def show
  end

  def create #104
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      sign_in(user)
      flash[:success] = "Welcome back, #{current_user.name_or_email}!"
      redirect_to root_path
    else
      flash[:warning] = 'Incorrect email and/or password'
      redirect_to new_session_path
    end
  end

  def destroy # 109
    sign_out
    flash[:success] = "See you later!"
    redirect_to root_path
  end
end