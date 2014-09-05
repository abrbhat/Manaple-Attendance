class PagesController < ApplicationController
  def main
  end

  def delayed_jobs
    @handlers = DelayedJob.pluck(:handler)
  end

  def troubleshoot_webcam_error

  end

  def download_amcap_setup
    setup_location = Rails.root.to_s + '/public/amcap_setup.zip'
    send_file setup_location, :type=>"application/zip", :x_sendfile=>true
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

  def enter_bulk_store_data
    unless current_user.is_account_manager?
      render :text => "You are not allowed here"
      return
    end
    @users = User.all.select{|user| !(user.is_store_common_user? or user.is_store_staff? or user.is_store_manager?)}
  end

  def create_bulk_stores
    unless current_user.is_account_manager?
      render :text => "You are not allowed here"
      return
    end
    new_store_data = params[:store_data]
    asm_list = params[:asm_ids]
    owner_list = params[:owner_ids]
    observer_list = params[:observer_ids]
    supervisor_list = params[:supervisor_ids]
    master_id = params[:master_id]
    new_store_data.each do |store_data|
      name = store_data["name"]
      password = store_data["password"]
      email = store_data["email"]
      phone_number = store_data["phone_number"]
      if name.present?
        common_user = User.create!(name: name, email: email, :password => password)
        store = Store.create(name: name, email: email, phone: phone_number)
        Authorization.create(user_id: common_user.id, store_id: store.id, permission: "common_user" )
        asm_list.each do |asm_id|
          if asm_id.present?
            Transfer.create(user_id: asm_id, to_store_id: store.id, date: Time.zone.now )
            Authorization.create(user_id: asm_id, store_id: store.id, permission: "asm" )
          end
        end
        observer_list.each do |observer_id|
          if observer_id.present?
            Authorization.create(user_id: observer_id, store_id: store.id, permission: "observer" )
          end
        end
        owner_list.each do |owner_id|
          if owner_id.present?
            Authorization.create(user_id: owner_id, store_id: store.id, permission: "owner" )
          end
        end
        supervisor_list.each do |supervisor_id|
          if supervisor_id.present?
            Authorization.create(user_id: supervisor_id, store_id: store.id, permission: "supervisor" )
          end
        end
        if master_id.present?
          Authorization.create(user_id: master_id, store_id: store.id, permission: "master" )
        end        
      end
    end
    redirect_to pages_enter_bulk_store_data_path, notice: "Stores Created"
    return
  end

  def select_bulk_authorizations_to_create
    unless current_user.is_account_manager?
      render :text => "You are not allowed here"
      return
    end 
    @stores = Store.all
    @users = User.all.select{|user| !(user.is_store_common_user? or user.is_store_staff? or user.is_store_manager?)}
  end

  def create_bulk_authorizations
    unless current_user.is_account_manager?
      render :text => "You are not allowed here"
      return
    end
    store_list = params[:store_ids]
    user_id = params[:user_id]
    permission = params[:permission]
    store_list.each do |store_id|
      store = Store.find(store_id)
      if !store.authorizations.exists?(:user_id => user_id)
        Authorization.create(user_id: user_id, store_id: store_id, permission: permission )
        if permission == "asm"
          Transfer.create(user_id: user_id, to_store_id: store_id, date: Time.zone.now )
        end
      end
    end
    redirect_to pages_select_bulk_authorizations_to_create_path, notice: "Authorizations Created"
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
