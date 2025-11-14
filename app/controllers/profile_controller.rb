class ProfileController < ApplicationController
  before_action :require_login
  def index
    @form = ProfileForm.new
  end

  def update
    @form = ProfileForm.new(profile_params)
    if @form.valid?
      result = ProfileService.update_profile(@form, current_user)
      if result
        flash[:success] = "Profile updated successfully."
      else
        flash.now[:error] = "Failed to update profile."
      end
    end
    render :index
  end

  private
  def profile_params
    params.require(:profile_form).permit(
      :name,
      :phone_number,
      :password,
      :password_confirmation,
      :avatar
    )
  end
end
