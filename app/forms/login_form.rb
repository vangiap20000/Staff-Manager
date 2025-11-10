class LoginForm
  @@isValidationEnabled = false
  @@user = nil

  include ActiveModel::Model

  attr_accessor :email, :password

  validates :email, presence: { message: "Email cannot be blank" }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: { message: "Password cannot be blank" }, length: { minimum: 8 }

  def self.validation_enabled
    @@isValidationEnabled
  end

  def self.user
    @@user
  end

  def login
    unless valid?
      @@isValidationEnabled = true
      return false
    end

    @@isValidationEnabled = false
    user = User.find_by(email: self.email)
    user&.authenticate(self.password)
    @@user = user
  end
end
