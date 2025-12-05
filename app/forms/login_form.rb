class LoginForm
  @@is_validation_enabled = false
  @@user = nil

  include ActiveModel::Model

  attr_accessor :email, :password

  validates :email, presence: { message: "Email cannot be blank" }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: { message: "Password cannot be blank" }, length: { minimum: 8 }

  def self.validation_enabled
    @@is_validation_enabled
  end

  def self.user
    @@user
  end

  def login
    unless valid?
      @@is_validation_enabled = true
      return false
    end

    @@is_validation_enabled = false
    user = UserService.find_user_by_email_and_not_in_role(
      self.email,
      Rails.configuration.const['role'][:member]
    )
    @@user = user
    user&.authenticate(self.password)
  end
end
