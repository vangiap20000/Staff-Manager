class TeamService
  def self.destroy_team(id)
    team = Team.find_by(id: id)
    return false unless team

    team.users.each do |user|
      user.avatar.purge if user.avatar.attached?
      user.destroy
    end

    team.destroy ? true : false
  end

  def self.create_team(form)
    team = Team.new(
      name: form.name,
      max_member: form.max_member
    )

    team.save ? true : false
  end

  def self.update_team(team, form)
    team.name = form.name
    team.max_member = form.max_member
    team.save ? team : false
  end

  def self.paginated_teams(page: 1, search: nil)
    teams = Team.order(id: :desc)
    teams = teams.where("name LIKE ?", "%#{search}%") if search.present?
    per_page = Rails.configuration.const['per_page']
    teams.page(page).per(per_page)
  end
end