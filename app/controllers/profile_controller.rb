class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = 'Profile updated successfully'
      redirect_to profile_path, notice: 'Profile updated successfully'
    else
      flash.now[:error] = 'Profile could not be updated'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :bio)
  end
end
