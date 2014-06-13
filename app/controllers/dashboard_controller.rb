class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def notification_settings
    incharge = current_user
    @mobile = incharge.store.phone
    @email = incharge.store.email
  end
  def notification_settings_update
    incharge = current_user
    incharge.stores.each do |store|
      store.phone = params[:notification_mobile]
      store.email = params[:notification_email]
      store.save
    end
    flash[:notice] = "Your settings have been saved"
    redirect_to dashboard_notification_settings_path
  end

  def employees
    @employees = []
    current_user.stores.each do |store|
      @employees = @employees + store.employees
    end
  end

  def create_employee
    @stores = current_user.stores
  end

  def create_new_employee
    name = params[:employee_name]
    store_name = params[:store_name]
    store = Store.where(name: store_name).first
    email = name.delete(' ').downcase
    email << "@manaple.com"
    while User.where(email: email).present? do
      email = name.delete(' ').downcase
      email << (0...4).map { ('a'..'z').to_a[rand(26)] }.join
      email << "@manaple.com"
    end
    user = User.create!(name: name, email: email, :password => Devise.friendly_token[0,20])
    Authorization.create(user_id: user.id, store_id: store.id, permission: "staff" )
    redirect_to(:controller => 'dashboard', :action => 'employees')
  end

  def attendance_specific_day
    @stores = current_user.stores
    @attendance_data_all = []
    if params[:date].blank?      
      @date = Time.zone.now
    else      
      @date = DateTime.strptime(params[:date]+' +05:30', '%d-%m-%Y %z')
    end
    if @date.midnight > Time.zone.now.midnight
      flash[:error] = "Date cannot be later than today"
      @date = Time.zone.now
    end
    @stores.each do |store|
      store.employees.each do |employee|        
        @attendance_data_all << employee.attendance_data_for(@date)
      end
    end    
    @attendance_data_paginated = Kaminari.paginate_array(@attendance_data_all).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def attendance_time_period
    @stores = current_user.stores
    @attendance_data_all = []
    @stores.each do |store|
      store.employees.each do |employee|
        attendance_data = Hash.new
        attendance_data["present_count"] = 0
        if params[:time_period_start].blank?
          @start_date = Time.zone.now
          @end_date = Time.zone.now
          @date = Time.zone.now.strftime("%d-%m-%Y")
        else
          @start_date = DateTime.strptime(params[:time_period_start]+' +05:30', '%d-%m-%Y %z')
          @end_date = DateTime.strptime(params[:time_period_end]+' +05:30', '%d-%m-%Y %z')
          @date = params[:date]
        end
        if @end_date < @start_date
          flash[:error] = "End Date has to be later than Start Date"
          return
        elsif @end_date.midnight > Time.zone.now.midnight
          flash[:error] = "End Date cannot be later than today"
          return
        end
        photos = employee.photos.where(created_at: (@start_date.midnight..@end_date.midnight + 1.day))
        present_on = {}
        photos.each do |photo|
          if (photo.description == 'in' or photo.description == 'out') and !(photo.status == "verification_rejected")       
            present_on[photo.created_at.strftime("%d-%m-%Y")] = true            
          end
        end
        attendance_data["present_count"] = present_on.count
        @working_days = (@end_date-@start_date).to_i + 1
        attendance_data["leave_count"] = 0
        (@start_date.to_date..(@end_date.midnight).to_date).each do |date|
          if employee.is_on_leave_on?(date)
            attendance_data["leave_count"] +=1
          end
        end
        attendance_data["absent_count"] = @working_days - attendance_data["present_count"] - attendance_data["leave_count"]
        attendance_data["employee"] = employee
        @attendance_data_all << attendance_data
      end
    end
    @attendance_data_paginated = Kaminari.paginate_array(@attendance_data_all).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def choose_employee_name
    @store = current_user.store
    @employees = @store.employees
  end
  def choose_attendance_description
    employee_id = params[:employee]
    @employee = User.find(employee_id)
    @store = @employee.store
    today_photos = @employee.photos.where(created_at: (Time.zone.now.midnight)..Time.zone.now.midnight + 1.day)
    in_photo = today_photos.select { |photo| photo.description == 'in' }
    out_photo = today_photos.select { |photo| photo.description == 'out' }    
    @in_attendance_marked_for_today = false
    @out_attendance_marked_for_today = false
    if in_photo.present?
      @in_attendance_marked_for_today = true
      @in_attendance_time = in_photo.last.created_at
    end
    if out_photo.present?
      @out_attendance_marked_for_today = true
      @out_attendance_time = out_photo.last.created_at
    end
  end
  def employee_attendance_record
    if params[:employee_id].blank?
      @employee = current_user.employees.first
    else
      @employee = User.find(params[:employee_id])
    end
    if !current_user.stores.include? @employee.store
      flash[:error] = 'You are not allowed there'
      redirect_to current_user.home_path
    end     
    if params[:time_period_start].blank?
      @start_date = Time.zone.now
      @end_date = Time.zone.now
      date = Time.zone.now.strftime("%d-%m-%Y")
    else
      @start_date = DateTime.strptime(params[:time_period_start]+' +05:30', '%d-%m-%Y %z')
      @end_date = DateTime.strptime(params[:time_period_end]+' +05:30', '%d-%m-%Y %z')
      date = params[:date]
    end
    @attendance_data_for = Hash.new
    (@start_date.to_date..(@end_date.midnight).to_date).each do |date|
      @attendance_data_for[date.strftime("%d-%m-%Y")] = @employee.attendance_data_for(date)
    end    
    @employees = current_user.employees
    @dates_all = (@start_date.to_date..(@end_date.midnight).to_date).to_a
    @dates_paginated = Kaminari.paginate_array(@dates_all).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.xls
    end
  end


  private

end
