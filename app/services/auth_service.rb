class AuthService
  def self.handel_authenticate(email, password)
    user = UserService.find_user_by_email_and_not_in_role(
      email,
      Rails.configuration.const['role'][:member]
    )

    return nil unless user
    return nil unless user.authenticate(password)
    
    user
  end
  
  def self.reset_password(email)
    user = User.find_by(email: email)
    if user
      new_password = SecureRandom.alphanumeric(10)

      user.update(password: new_password)

      UserMailer.with(user: user, password: new_password).send_new_password.deliver_now

      return true
    end

    return false
  end
end