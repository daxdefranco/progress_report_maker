class PasswordResetsController < ApplicationController
  
  def new
    @title = "Reset your password"
  end
  
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to login_path, 
                :notice => "Please check your email for instructions to reset your password"
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to login_path, :notice => "Password has been reset!"
    else
      view_context.flash_failure
      render :edit
    end
  end

end
