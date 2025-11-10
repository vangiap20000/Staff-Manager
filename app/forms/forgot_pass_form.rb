class ForgotPassForm
  @@isValidationEnabled = false
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: { message: "Email cannot be blank" }, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.validation_enabled
    @@isValidationEnabled
  end

  def forgotPassword
    unless valid?
      @@isValidationEnabled = true
      return false
    end

    user = User.find_by(email: self.email)
    if user
      new_password = SecureRandom.alphanumeric(10)

      user.update(password: new_password, password_confirmation: new_password)

      UserMailer.with(user: user, password: new_password).send_new_password.deliver_now

      flash[:notice] = "A new password has been sent to your email."
      redirect_to login_path
    else
      flash[:alert] = "Email not found."
      render :new
    end
  end
end
