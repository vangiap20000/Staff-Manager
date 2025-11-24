class TeamService
  def self.destroy_team(id)
    team = Team.find(id)
    return false unless team
    
    User.where(team_id: id).update_all(created_by_id: nil)

    team.destroy ? true : false
  end

  def self.create_team(form)
    team = Team.new(form.to_h)
    team.save ? true : false
  end

  def self.update_team(team, form)
    result = team.update(form.to_h)
    result ? team : false
  end

  def self.paginated_teams(page: 1, search: nil)
    teams = Team.order(id: :desc)
    teams = teams.where("name LIKE ?", "%#{search}%") if search.present?
    per_page = Rails.configuration.const['per_page']
    teams.page(page).per(per_page)
  end
end