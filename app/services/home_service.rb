class HomeService
   def self.dashboard_stats
    role = Rails.configuration.const['role']
    teams = Team.all
    {
      teams: teams.map(&:name),
      users_count: User.count,
      teams_count: teams.count,
      admins_count: User.where(role: role[:admin]).count,
      team_full_count: get_team_full_count,
      users_by_team: get_users_by_team(teams),
      users_by_role: get_users_by_role,
      teams_status: get_teams_status,
      users_over_time: get_users_over_time,
      team_capacity: get_team_capacity(teams)
    }
  end

  def self.get_users_over_time
    User.group_by_month(:created_at, last: 6).count.values
  end

  def self.get_team_full_count
    subquery = Team.select(
      'teams.*, (SELECT COUNT(id) FROM users WHERE users.team_id = teams.id) AS number_user_in_team'
    )

    Team
      .from("(#{subquery.to_sql}) AS teams_with_count")
      .where('max_member <= number_user_in_team')
      .count
  end
  def self.get_team_full_count
    subquery = Team
      .select('teams.*, (SELECT COUNT(id) FROM users WHERE users.team_id = teams.id) AS number_user_in_team')
    
    Team
      .from("(#{subquery.to_sql}) AS teams_with_count")
      .where('max_member <= number_user_in_team')
    .count
  end

  def self.get_users_by_role
    roles = Rails.configuration.const['role']
    [
      User.where(role: roles[:superAdmin]).count,
      User.where(role: roles[:admin]).count,
      User.where(role: roles[:member]).count
    ]
  end

  def self.get_teams_status
    [
      Team.joins(:users).group("teams.id").having("COUNT(users.id) < teams.max_member").to_a.size,
      Team.joins(:users).group("teams.id").having("COUNT(users.id) >= teams.max_member").to_a.size
    ]
  end

  def self.get_users_by_team(teams)
    teams.map { |t| t.users.count }
  end

  def self.get_team_capacity(teams)
    teams.map do |t|
      { team: t.name, current: t.users.count, max: t.max_member }
    end
  end
end