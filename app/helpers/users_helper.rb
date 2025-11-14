module UsersHelper
  def is_supper_admin
    current_user.role == Rails.configuration.const['role'][:superAdmin]
  end

  def check_max_member(team_id = nil)
    team_id ||= current_user.team_id
    team = Team.find_by(id: team_id)
    return false unless team

    max_members = team.max_member || 0
    current_member_count = User.where(team_id: team_id).count + 1

    current_member_count > max_members
  end
  
  def check_is_my_member(user, current_user_param = nil)
    current_user_val = current_user_param || current_user
    return false unless user
    return true if current_user_val.role == Rails.configuration.const['role'][:superAdmin]
    return false if current_user_val.team_id != user.team_id
    true
  end
end
