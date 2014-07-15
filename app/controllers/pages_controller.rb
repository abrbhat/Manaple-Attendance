class PagesController < ApplicationController
  def main
  end

  def send_notification_mail
  	User.mail_stores_attendance
  end

  def send_mail
  end

  def send_test_mail
    AdminMailer.notification().deliver
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
      if photo.user.present?
        photo.store_id = photo.user.store.id
        photo.save
      end
    end
    render :text => "done"
  end

  def create_initial_transfers
    # this is retrospective action to be run only once
    User.all.each do |employee|
      if employee.store.present?
        Transfer.create(user_id: employee.id, to_store_id: employee.store.id, date: employee.authorizations.first.created_at )
      end
    end
    render :text => "transfer created"
  end

end
