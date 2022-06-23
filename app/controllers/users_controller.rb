class UsersController < ApplicationController
  before_action :require_no_authentication, only: %i[new create] # 112 new, create
  before_action :require_authentication, only: %i[edit update] # 112
  before_action :set_user!, only: %i[edit update] # 112, 116

  def edit
  end

  def update # 116
    if @user.update user_params
      flash[:success] = 'Your profile was successfully updated!'
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def new
    @user = User.new # 81
  end

  def create # 82
    @user = User.new(user_params)
    if @user.save
      sign_in(@user) # 104
      flash[:success] = "Welcome to the app, #{current_user.name_or_email}!" # 94
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def set_user! # 113
    @user = User.find(params[:id])
  end

  def user_params # 82
    params.require(:user).permit(:email, :name, :password,:password_confirmation, :old_password) # 120 old_password
  end
end
