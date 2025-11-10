class UserMailer < ApplicationMailer
    default from: "no-reply@example.com"

    def send_new_password
        @user = params[:user]
        @password = params[:password]
        mail(to: @user.email, subject: "Your new password")
    end
end
