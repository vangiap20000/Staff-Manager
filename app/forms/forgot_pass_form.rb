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
    AuthService.reset_password(email)
  end
end
