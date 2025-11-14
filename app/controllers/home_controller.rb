class HomeController < ApplicationController
  before_action :require_login, :is_supper_admin
  def index
    roles = Rails.configuration.const['role']
    @users_count = User.count
    @teams_count = Team.count
    @admins_count = User.where(role: roles[:admin]).count
    subquery = Team
      .select('teams.*, (SELECT COUNT(id) FROM users WHERE users.team_id = teams.id) AS number_user_in_team')

    @team_full_count = Team
      .from("(#{subquery.to_sql}) AS teams_with_count")
      .where('max_member <= number_user_in_team')
    .count

    @teams = Team.all
    @users_by_team = @teams.map { |t| t.users.count }
    @users_by_role = [
      User.where(role: roles[:superAdmin]).count,
      User.where(role: roles[:admin]).count,
      User.where(role: roles[:member]).count
    ]

    @teams_status = [
      Team.joins(:users).group("teams.id").having("COUNT(users.id) < teams.max_member").to_a.size,
      Team.joins(:users).group("teams.id").having("COUNT(users.id) >= teams.max_member").to_a.size
    ]

    @users_over_time = User.group_by_month(:created_at, last: 6).count.values

    @team_capacity = @teams.map do |t|
      { team: t.name, current: t.users.count, max: t.max_member }
    end
  end
end
