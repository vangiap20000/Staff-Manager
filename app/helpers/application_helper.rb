module ApplicationHelper
  def is_supper_admin
    current_user.role == Rails.configuration.const['role'][:superAdmin]
  end
end
