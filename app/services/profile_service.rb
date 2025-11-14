class ProfileService
  def self.update_profile(form, user)
    user.name = form.name
    user.phone_number = form.phone_number

    if form.password.present?
      user.password = form.password
    end

    if form.avatar.present?
      user.avatar.purge if user.avatar.attached?
      user.avatar.attach(form.avatar)
    end

    user.save ? user : nil
  end
end