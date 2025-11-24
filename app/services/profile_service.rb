class ProfileService
  def self.update_profile(form, user)
    result = user.update(form.to_h)
    if result && form.avatar.present?
      user.avatar.purge if user.avatar.attached?
      user.avatar.attach(form.avatar)
    end

    result ? user : nil
  end
end