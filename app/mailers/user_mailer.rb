class UserMailer < ApplicationMailer
    default from: "no-reply@staff-manager.com"

    def send_new_password
        @user = params[:user]
        @password = params[:password]
        @login_url = login_url
        mail(to: @user.email, subject: "Your new password")
    end
end
