class DashboardController < ApplicationController

  before_filter :authenticate_user!
  before_filter :verify_authorization
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

  def attendance_specific_day
    # Uncomment to test mail sending
    # AsmMailer.notification().deliver
    @stores = current_user.stores
    @attendance_data = []
    if params[:date].blank?      
      @date = Time.now
    else      
      @date = DateTime.strptime(params[:date]+' +05:30', '%d-%m-%Y %z')
    end
    if @date.midnight > Time.now.midnight
      flash[:error] = "Date cannot be later than today"
      return
    end
    @stores.each do |store|
      store.employees.each do |employee|
        attendance_data = Hash.new
        photos = employee.photos.where(created_at: @date.midnight..@date.midnight + 1.day)
        in_photos = photos.select {|photo| photo.description=="in"}
        out_photos = photos.select {|photo| photo.description=="out"}
        if in_photos.present?
          attendance_data["in_time"] = in_photos.last.created_at.strftime("%I:%M%p")
          attendance_data["in_status"] = in_photos.last.status
        end
        if out_photos.present?
          attendance_data["out_time"] = out_photos.last.created_at.strftime("%I:%M%p")
          attendance_data["out_status"] = out_photos.last.status
        end
        attendance_data["employee"] = employee
        @attendance_data << attendance_data
      end
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def attendance_time_period
    @stores = current_user.stores
    @attendance_data = []
    @stores.each do |store|
      store.employees.each do |employee|
        attendance_data = Hash.new
        attendance_data["present_count"] = 0
        if params[:time_period_start].blank?
          @start_date = Time.now
          @end_date = Time.now
          @date = Time.now.strftime("%d-%m-%Y")
        else
          @start_date = DateTime.strptime(params[:time_period_start]+' +05:30', '%d-%m-%Y %z')
          @end_date = DateTime.strptime(params[:time_period_end]+' +05:30', '%d-%m-%Y %z')
          @date = params[:date]
        end
        if @end_date < @start_date
          flash[:error] = "End Date has to be later than Start Date"
          return
        elsif @end_date.midnight > Time.now.midnight

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
        attendance_data["absent_count"] = @working_days - attendance_data["present_count"]
        attendance_data["employee"] = employee
        @attendance_data << attendance_data
      end
    end
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
    today_photos = @employee.photos.where(created_at: (Time.now.midnight)..Time.now.midnight + 1.day)
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
      @start_date = Time.now
      @end_date = Time.now
      @date = Time.now.strftime("%d-%m-%Y")
    else
      @start_date = DateTime.strptime(params[:time_period_start]+' +05:30', '%d-%m-%Y %z')
      @end_date = DateTime.strptime(params[:time_period_end]+' +05:30', '%d-%m-%Y %z')
      @date = params[:date]
    end
    photos = @employee.photos.where(created_at: (@start_date.midnight..@end_date.midnight + 1.day))
    @attendance_data = {}
    photos.each do |photo|
      if !(photo.status == "verification_rejected")       
        @attendance_data[photo.created_at.strftime("%d-%m-%Y")] = {}
        @attendance_data[photo.created_at.strftime("%d-%m-%Y")][photo.description] = photo.created_at.strftime("%I:%M%p")          
        if (photo.description == 'in' or photo.description == 'out')
          @attendance_data[photo.created_at.strftime("%d-%m-%Y")]['status'] = 'present'
        end
      end
    end
    @employees = current_user.employees
  end
  private
  def verify_authorization
    action = params[:action]
    unless current_user.can_access.include? ("dashboard/"+action) 
      flash[:error] = 'You are not allowed there'
      redirect_to current_user.home_path
    end
  end
end
