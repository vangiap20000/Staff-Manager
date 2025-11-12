module UsersHelper
  def paginated_users(page: 1, per_page: 10, search: nil)
    user = User.order(:id)
    user = user.where("name LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%") if search.present?
    if current_user.role == Rails.configuration.const['role'][:admin]
      user = user.where(created_by_id: current_user.id).where(role: Rails.configuration.const['role'][:member])
    end

    user.page(page).per(per_page)
  end

  def destroy_user(id)
    user = User.find_by(id: params[:id])
    unless user
      return false
    end

    role = Rails.configuration.const['role']
    if user.role == role[:admin] && current_user.role == role[:super_admin]
      user_children = User.where(created_by_id: user.id).where(role: role[:member])
      user_children.destroy_all if user_children.count > 1
    end

    user.avatar.purge if user.avatar.attached?

    user.destroy ? true : false
  end

  def is_supper_admin
    current_user.role == Rails.configuration.const['role'][:superAdmin]
  end

  def create_user(form)
    user = User.new(
      name: form.name,
      email: form.email,
      phone_number: form.phone_number,
      role: form.role,
      team_id: form.team_id,
      created_by_id: form.current_user.id,
      password: form.password
    )

    if user.save && form.avatar.present?
      user.avatar.attach(form.avatar)
    end

    user.persisted? ? user : nil
  end
  
end
