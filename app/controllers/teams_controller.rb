class TeamsController < ApplicationController
  before_action :require_login, :is_supper_admin 
  def index
    page = params[:page] || 1
    search = params[:search]
    @teams = TeamService.paginated_teams(page: page, search: search)
  end

  def new
    @form = TeamForm.new
  end

  def edit
    @team = Team.find_by(id: params[:id])
    if @team.nil?
      flash[:error] = "Team not found."
      redirect_to teams_path
      return
    end

    @form = TeamForm.new
  end

  def create
    @form = TeamForm.new(team_params)

    if @form.valid?
      result = TeamService.create_team(@form)
      if result
        flash[:success] = "Team created successfully."
        redirect_to teams_path
      else
        flash.now[:error] = "Failed to create Team."
        render :new
      end
    else
      render :new
    end
  end

  def update
    @team = Team.find_by(id: params[:id])
    if @team.nil?
      flash[:error] = "Team not found."
      redirect_to teams_path
      return
    end

    @form = TeamForm.new(team_params.merge(id: @team.id))
    if @form.valid?
      result = TeamService.update_team(@team, @form)
      if result
        flash[:success] = "Team updated successfully."
      else
        flash.now[:error] = "Failed to update Team."
      end
    end

    render :edit
    return
  end

  def destroy
    result = TeamService.destroy_team(params[:id])
    if result
      flash[:success] = "Team deleted successfully."
    else
      flash[:error] = "Failed to delete team."
    end

    redirect_to teams_path
  end

  private
  def team_params
      params.require(:team_form).permit(
        :name,
        :max_member
      )
  end

end
