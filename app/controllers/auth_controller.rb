class AuthController < ApplicationController
  layout "authentication"
  
  def login
    @form = LoginForm.new
  end

  def handelLogin
    @form = LoginForm.new(login_params)
    if @form.save
      redirect_to root_path, notice: "Login successfully!"
    else
      render :login
    end
  end

  def forgotPassword
    @forgotPassForm = ForgotPassForm.new
    render "auth/forgot_password"
  end

  def handelForgotPassword
    @forgotPassForm = ForgotPassForm.new(forgot_pass_params)
    if @forgotPassForm.save
      redirect_to forgot_password_path, notice: "Forgot password successfully, we have sent you the password via email!"
    else
      render "auth/forgot_password"
    end
  end

  private
  
  def login_params
    params.require(:login_form).permit(:email, :password)
  end

  def forgot_pass_params
    params.require(:forgot_pass_form).permit(:email)
  end
end
