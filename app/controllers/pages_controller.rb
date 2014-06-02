class PagesController < ApplicationController
  def main
  end

  def send_notification_mail
  	User.mail_stores_attendance
  end

end
