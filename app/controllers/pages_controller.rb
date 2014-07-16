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
    if admin_user_signed_in?
      Photo.all.each do |photo|
        if photo.user.present?
          photo.store_id = photo.user.store.id
          photo.save
        end
      end
      render :text => "done"
    else
      render :text => "You need to be admin"
    end
  end

  def create_initial_transfers
    if admin_user_signed_in?
      # this is retrospective action to be run only once
      User.all.each do |employee|
        if employee.store.present?
          Transfer.create(user_id: employee.id, to_store_id: employee.store.id, date: employee.authorizations.first.created_at )
        end
      end
      render :text => "transfer created"
    else
      render :text => "You need to be admin"
    end 
  end

  def trasnfer_photos_view
    if admin_user_signed_in?
      # this is retrospective action to be run only once
      @users = User.all
    else
      render :text => "You need to be admin"
      return
    end 
  end

  def transfer_photos
    if admin_user_signed_in?
      from_user = User.find(params[:from_user_id])
      to_user = User.find(params[:to_user_id])
      from_user.photos.each do |photo|
        photo.user_id = to_user.id
        photo.save
      end
      render :text => "Photos transferred"
    else
      render :text => "You need to be admin"
      return
    end 
  end

end
