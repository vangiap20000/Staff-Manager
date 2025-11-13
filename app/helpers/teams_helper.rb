module TeamsHelper
  def paginated_teams(page: 1, per_page: 10, search: nil)
    team = Team.order(:id)
    team = team.where("name LIKE ?", "%#{search}%") if search.present?
    team.page(page).per(per_page)
  end

  def destroy_team(id)
    team = Team.find_by(id: id)

    users = User.where(team_id: id)
    users.each do |user|
      user.avatar.purge if user.avatar.attached?
      user.destroy
    end

    return false unless team

    team.destroy ? true : false
  end

  def create_team(form)
    team = Team.new(
      name: form.name,
      max_member: form.max_member
    )

    team.save ? true : false
  end

  def update_team(team, form)
    team.name = form.name
    team.max_member = form.max_member

    team.save ? true : false
  end
end
