class PagesController < ApplicationController
  def main
  end

  def delayed_jobs
    @handlers = DelayedJob.pluck(:handler)
  end

  def choose_attendance_mail_date
    @date = Time.zone.now
  end

  def choose_attendance_mail_date_specific_user
    @date = Time.zone.now
    @users = User.all.select{|user| user.should_receive_daily_attendance_notification_mail?}
  end

  def send_test_mail
    AdminMailer.notification().deliver
  end

  def send_specific_day_notification_mail
    if params[:date].present?
      @date = DateTime.strptime(params[:date]+' +05:30', '%d-%m-%Y %z')
    else
      @date = Time.zone.now
    end
    User.mail_stores_specific_day_attendance(@date)
  end

  def send_specific_day_notification_mail_specific_user
    if params[:date].present?
      @date = DateTime.strptime(params[:date]+' +05:30', '%d-%m-%Y %z')
    else
      @date = Time.zone.now
    end
    @users = []
    user_ids = params[:to_user_ids]
    user_ids.each do |user_id|
      user = User.find(user_id)
      user.mail_stores_specific_day_attendance_specific_user(@date)
      @users << user
    end   
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
      if Transfer.all.blank?
      # this is retrospective action to be run only once
        User.all.each do |employee|
            if employee.is_eligible_for_attendance?
              employee.stores.each do |store|
                authorization = employee.authorizations.select{|authorization| authorization.store == store}.first
                Transfer.create(user_id: employee.id, to_store_id: store.id, date: authorization.created_at )
              end
            end
        end
        render :text => "transfer created"
      else
        render :text => "transfers already present"
      end
    else
      render :text => "You need to be admin"
    end 
  end

  def transfer_attendance_data_view
    if admin_user_signed_in?
      @users = User.all
    else
      render :text => "You need to be admin"
      return
    end 
  end

  def transfer_attendance_data
    if admin_user_signed_in?
      from_user = User.find(params[:from_user_id])
      to_user = User.find(params[:to_user_id])
      from_user.photos.each do |photo|
        photo.user_id = to_user.id
        photo.save
      end
      from_user.leaves.each do |leave|
        leave.user_id = to_user.id
        leave.save
      end
      render :text => "Photos and Leaves transferred"
    else
      render :text => "You need to be admin"
      return
    end 
  end

end
