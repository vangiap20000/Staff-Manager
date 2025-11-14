module UsersHelper
  def paginated_users(page: 1, per_page: 10, search: nil)
    user = User.order(id: :desc)
    user = user.where("name LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%") if search.present?
    if current_user.role == Rails.configuration.const['role'][:admin]
      user = user.where(team_id: current_user.team_id).where(role: Rails.configuration.const['role'][:member])
    elsif current_user.role == Rails.configuration.const['role'][:superAdmin]
      user = user.where.not(role: Rails.configuration.const['role'][:superAdmin])
    end

    user.page(page).per(per_page)
  end

  def destroy_user(id)
    user = User.find_by(id: params[:id])
    return false unless user
    return false if current_user.id == user.id
    return false unless check_is_my_member(user)

    role = Rails.configuration.const['role']
    if user.role == role[:admin] && current_user.role == role[:super_admin]
      user_children = User.where(created_by_id: user.id).where(role: role[:member])
      user_children.destroy_all if user_children.count > 1
    end

    user.avatar.purge if user.avatar.attached?

    user.destroy ? true : false
    true
  end

  def is_supper_admin
    current_user.role == Rails.configuration.const['role'][:superAdmin]
  end

  def create_user(form)
    if form.current_user.role == Rails.configuration.const['role'][:admin]
      form.role = Rails.configuration.const['role'][:member]
      form.team_id = form.current_user.team_id
    else

    end
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

  def update_user(form, user)
    user.name = form.name
    user.email = form.email
    user.phone_number = form.phone_number
    if form.current_user.role == Rails.configuration.const['role'][:superAdmin]
      user.role = form.role
      user.team_id = form.team_id
    end

    if form.password.present?
      user.password = form.password
    end

    if form.avatar.present?
      user.avatar.purge if user.avatar.attached?
      user.avatar.attach(form.avatar)
    end

    user.save ? user : nil
  end

  def check_max_member(team_id = nil)
    team_id ||= current_user.team_id
    team = Team.find_by(id: team_id)
    return false unless team

    max_members = team.max_member || 0
    current_member_count = User.where(team_id: team_id).count + 1

    current_member_count > max_members
  end
  
  def check_is_my_member(user)
    return false unless user
    return true if current_user.role == Rails.configuration.const['role'][:superAdmin]
    return false if current_user.team_id != user.team_id
    true
  end

end
