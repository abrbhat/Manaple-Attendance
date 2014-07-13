class PagesController < ApplicationController
  def main
  end

  def send_notification_mail
  	User.mail_stores_attendance
  end

  def send_mail
    
  end

  def send_specific_day_notification_mail
    if params[:date].present?
      @date = params[:date]
    else
      @date = Date.today
    end
    User.mail_stores_specific_day_attendance(@date)
  end

  
  def allot_stores
    # this is retrospective action to be run only once
    Photo.all.each do |photo|
      photo.store_id = photo.user.store.id
      photo.save
    end
    render :text => "done"
  end

end
