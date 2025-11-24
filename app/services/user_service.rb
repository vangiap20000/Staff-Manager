class UserService
  include UsersHelper

  def initialize(current_user)
    @current_user = current_user
    @const = Rails.configuration.const
  end

  def paginated_users(page: 1, search: nil, role: nil, team_id: nil)
    user = User.order(id: :desc)
    user = user.where("name LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%") if search.present?
    role_config = @const['role']

    case true
    when is_admin(@current_user)
      user = user.where(team_id: @current_user.team_id).where(role: role_config[:member])
    when is_supper_admin(@current_user)
      user = user.where.not(role: role_config[:superAdmin])
      user = user.where(role: role) if role.present?
      user = user.where(team_id: team_id) if team_id.present?
    end

    per_page = @const['per_page']
    user.page(page).per(per_page)
  end

  def destroy_user(id)
    user = User.find_by(id: id)
    return false unless user
    return false if @current_user.id == user.id
    return false unless check_is_my_member(user, @current_user)

    role = @const['role']
    if is_admin(user) && is_supper_admin(@current_user)
      User.where(created_by_id: user.id).where(role: role[:member]).destroy_all
    end

    user.avatar.purge if user.avatar.attached?

    user.destroy ? true : false
  end

  def create_user(form)
    data = form.to_h
    if is_admin(form.current_user)
      data['role'] = @const['role'][:member]
      data['team_id'] = form.current_user.team_id
    end

    user = User.new(data)

    user.avatar.attach(form.avatar) if user.save && form.avatar.present?

    user.persisted? ? user : nil
  end

  def update_user(form, user)
    data = form.to_h

    data.except!("created_by_id")
    data.except!("role", "team_id") if is_admin(form.current_user)

    result = user.update(data)

    if result && form.avatar.present?
      user.avatar.purge if user.avatar.attached?
      user.avatar.attach(form.avatar)
    end
    
    result ? user : nil
  end

  def self.find_user_by_email_and_not_in_role(email, role)
    User.where(email: email)
      .where.not(role: role)
      .first
  end

end