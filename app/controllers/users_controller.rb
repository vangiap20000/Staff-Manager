class UsersController < ApplicationController
  before_action :set_roles_and_teams, :require_login
  include UsersHelper

  def index
    page = params[:page] || 1
    perPage = Rails.configuration.const['per_page']
    search = params[:search]
    @roles = Rails.configuration.const['role_value']
    @users = paginated_users(page: page, per_page: perPage, search: search)
  end

  def destroy
    result = destroy_user(params[:id])
    if result
      flash[:success] = "User deleted successfully."
    else
      flash[:error] = "Failed to delete user."
    end

    redirect_to users_path
  end

  def new
    @form = UserForm.new
  end

  def create
    @form = UserForm.new(user_params.merge(current_user: current_user))

    if check_max_member(@form.team_id)
      flash.now[:error] = "Cannot create more members. Maximum limit reached."
      render :new
      return
    end

    if @form.valid?
      result = create_user(@form)
      if result
        flash[:success] = "User created successfully."
        redirect_to users_path
      else
        flash.now[:error] = "Failed to create user."
        render :new
      end
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
    if @user.nil? || current_user.id == @user.id
      flash[:error] = "User not found."
      redirect_to users_path
      return
    end

    @form = UserForm.new
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.nil? || current_user.id == @user.id
      flash[:error] = "User not found."
      redirect_to users_path
      return
    end

    @form = UserForm.new(user_params.merge(current_user: current_user, id: params[:id]))
    if @form.valid?
      result = update_user(@form, @user)
      if result
        flash[:success] = "User updated successfully."
      else
        flash.now[:error] = "Failed to update user."
      end
    end

    render :edit
  end

  private
  def user_params
      params.require(:user_form).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        :team_id,
        :role,
        :avatar,
        :phone_number
      )
  end

  def set_roles_and_teams
    constants = Rails.configuration.const

    @roles_values = constants['role_value'].dup 
    @roles_values.delete(1)
    @role_value_options = @roles_values.map { |key, value| [value, key] }
    @roles = constants['role']

    @teams = Team.all
    @team_options = @teams.map { |t| [t.name, t.id] }
  end
end
