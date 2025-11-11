class UsersController < ApplicationController
  before_action :require_login
  include UsersHelper

  def index
    page = params[:page] || 1
    per_page = Rails.configuration.const['per_page']
    search = params[:search]
    @roles = Rails.configuration.const['role_value']
    @users = paginated_users(page: page, per_page: per_page, search: search)
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
    @user = User.new
  end
end
