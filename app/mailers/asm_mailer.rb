class AsmMailer < ActionMailer::Base
  default from: "no-reply@manaple.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.thankyou.subject
  #
  def notification(user)
  	@user = user
    mail to: @user.email, subject: "Attendance at your Stores"
  end

end
