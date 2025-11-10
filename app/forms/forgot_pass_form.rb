class ForgotPassForm
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: { message: "Email cannot be blank" }, format: { with: URI::MailTo::EMAIL_REGEXP }

  def save
    return false unless valid?
    User.create(email: email)
  end
end
