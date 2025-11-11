class AuthController < ApplicationController
  before_action :redirect_if_logged_in, only: [:login, :handelLogin, :forgotPassword, :handelForgotPassword]
  layout "authentication"
  
  def login
    @form = LoginForm.new
  end

  def handelLogin
    @form = LoginForm.new(login_params)
    if @form.login
      session[:user_id] = LoginForm.user.id
      flash[:notice] = "Login successful!"
      redirect_to root_path
    else
      unless LoginForm.validation_enabled
        flash.now[:alert] = "Incorrect email or password"
      end
      render :login
    end
  end

  def forgotPassword
    @forgotPassForm = ForgotPassForm.new
    render "auth/forgot_password"
  end

  def handelForgotPassword
    @forgotPassForm = ForgotPassForm.new(forgot_pass_params)
    if @forgotPassForm.forgotPassword
      flash[:notice] = "Forgot password successfully, we have sent you the password via email!"
      redirect_to login_path
    else
      unless ForgotPassForm.validation_enabled
        flash.now[:alert] = "Email not found."
      end
      render "auth/forgot_password"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Signed out"
    redirect_to login_path
  end

  private
  
  def login_params
    params.require(:login_form).permit(:email, :password)
  end

  def forgot_pass_params
    params.require(:forgot_pass_form).permit(:email)
  end
end
