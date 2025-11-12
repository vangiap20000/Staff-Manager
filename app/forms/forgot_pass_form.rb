class ForgotPassForm
  @@is_validation_enabled = false
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: { message: "Email cannot be blank" }, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.validation_enabled
    @@is_validation_enabled
  end

  def forgot_password
    unless valid?
      @@is_validation_enabled = true
      return false
    end

    @@is_validation_enabled = false
    user = User.find_by(email: self.email)
    if user
      new_password = SecureRandom.alphanumeric(10)

      user.update(password: new_password)

      UserMailer.with(user: user, password: new_password).send_new_password.deliver_now

      return true
    end

    return false

  end
end
