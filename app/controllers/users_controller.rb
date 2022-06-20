class UsersController < ApplicationController
  def new
    @user = User.new # 81
  end

  def create # 82
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id # 84
      flash[:success] = "Welcome to the app, #{@user.name}!"
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params # 82
    params.require(:user).permit(:email, :name, :password,:password_confirmation)
  end
end
