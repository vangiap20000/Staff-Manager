class HomeController < ApplicationController
  before_action :require_login, :is_supper_admin
  def index
    @stats = HomeService.dashboard_stats
  end
end
