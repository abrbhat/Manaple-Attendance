class DashboardController < ApplicationController
  before_filter :authenticate_user_from_token!
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
    @employee_code_enabled = current_user.stores.first.employee_code_enabled
    @employee_designation_enabled = current_user.stores.first.employee_designation_enabled
    current_user.stores.each do |store|
      @employees = @employees + store.all_employees
    end
  end

  def create_employee
    @stores = current_user.stores
    @employee_code_enabled = @stores.first.employee_code_enabled
    @employee_designation_enabled = @stores.first.employee_designation_enabled
  end

  def create_new_employee
    name = params[:employee_name]
    employee_code = params[:employee_code]
    employee_designation = params[:employee_designation]
    store_name = params[:store_name]
    store = Store.where(name: store_name).first
    email = name.delete(' ').downcase
    email << "@manaple.com"
    while User.where(email: email).present? do
      email = name.delete(' ').downcase
      email << (0...4).map { ('a'..'z').to_a[rand(26)] }.join
      email << "@manaple.com"
    end
    user = User.create!(name: name, email: email, :password => Devise.friendly_token[0,20], employee_code: employee_code, employee_designation: employee_designation)
    Authorization.create(user_id: user.id, store_id: store.id, permission: "staff" )
    redirect_to(:controller => 'dashboard', :action => 'employees')
  end

  def attendance_specific_day
    @stores = current_user.stores
    @employee_code_enabled = @stores.first.employee_code_enabled
    @employee_designation_enabled = @stores.first.employee_designation_enabled
    @attendance_data_all = []
    @date = get_date
    @mid_day_enabled = false
    @mid_day_in_out_enabled = false
    if @date.midnight > Time.zone.now.midnight
      flash[:error] = "Date cannot be later than today"
      @date = Time.zone.now
    end
    @stores.each do |store|
      @mid_day_enabled = true if store.mid_day_enabled
      @mid_day_in_out_enabled = true if store.mid_day_in_out_enabled
      store.employees.each do |employee|  
        attendance_data = employee.attendance_data_for(@date)
        attendance_data['store'] = store 
        @attendance_data_all << attendance_data
      end
    end    
    @attendance_data_all.sort_by!{|attendance_data| [attendance_data['store'].name,attendance_data['employee'].name.capitalize]}
    @attendance_data_paginated = Kaminari.paginate_array(@attendance_data_all).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.xls
      format.json { render :json => {"got json"=>"true"} }
    end

  end

  def attendance_time_period_consolidated
    @stores = current_user.stores
    @employee_code_enabled = @stores.first.employee_code_enabled
    @employee_designation_enabled = @stores.first.employee_designation_enabled
    @attendance_data_all = []
    @start_date = get_start_date
    @end_date = get_end_date
    if @end_date < @start_date
      flash[:error] = "End Date has to be later than Start Date"
      @start_date = Time.zone.now
      @end_date = Time.zone.now
    end
    if @end_date.midnight > Time.zone.now.midnight
      flash[:error] = "End Date cannot be later than today"
      @start_date = Time.zone.now
      @end_date = Time.zone.now
    end
    @stores.each do |store|
      store.employees.each do |employee|        
        attendance_data = Hash.new
        attendance_data["employee"] = employee
        attendance_data["store"] = store
        attendance_data["present_count"] = 0
        attendance_data["absent_count"] = 0
        attendance_data["leave_count"] = 0
        attendance_data_for = Hash.new
        (@start_date.to_date..(@end_date.midnight).to_date).each do |date|
          attendance_data_for[date.strftime("%d-%m-%Y")] = Hash.new
          attendance_data_for[date.strftime("%d-%m-%Y")] = employee.attendance_data_for(date)
          attendance_status = attendance_data_for[date.strftime("%d-%m-%Y")]["status"]
          case attendance_status
          when "present"
            attendance_data["present_count"] += 1
          when "absent"
            attendance_data["absent_count"] += 1
          when "on_leave"
            attendance_data["leave_count"] += 1
          end
        end       
        @attendance_data_all << attendance_data
      end
    end
    @attendance_data_all.sort_by!{|attendance_data| [attendance_data['store'].name,attendance_data['employee'].name.capitalize]}
    @attendance_data_paginated = Kaminari.paginate_array(@attendance_data_all).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def attendance_time_period_detailed
    @stores = current_user.stores
    @employee_code_enabled = @stores.first.employee_code_enabled
    @employee_designation_enabled = @stores.first.employee_designation_enabled
    @attendance_data_all = []
    @start_date = get_start_date
    @end_date = get_end_date
    if @end_date < @start_date
      flash[:error] = "End Date has to be later than Start Date"
      @start_date = Time.zone.now
      @end_date = Time.zone.now
    end
    if @end_date.midnight > Time.zone.now.midnight
      flash[:error] = "End Date cannot be later than today"
      @start_date = Time.zone.now
      @end_date = Time.zone.now
    end
    @stores.each do |store|
      store.employees.each do |employee|   
        attendance_data_for = Hash.new
        (@start_date.to_date..(@end_date.midnight).to_date).each do |date|
          attendance_data_for[date.strftime("%d-%m-%Y")] = Hash.new
          attendance_data_for[date.strftime("%d-%m-%Y")] = employee.attendance_data_for(date)
          attendance_data_for[date.strftime("%d-%m-%Y")]["store"] = store                   
          @attendance_data_all << attendance_data_for[date.strftime("%d-%m-%Y")]
        end  
      end   
    end
    @attendance_data_all.sort_by!{|attendance_data| [attendance_data['date'],attendance_data['store'].name,attendance_data['employee'].name.capitalize]}
    @attendance_data_paginated = Kaminari.paginate_array(@attendance_data_all).page(params[:page]).per(30)
    @dates_all = (@start_date.to_date..(@end_date.midnight).to_date).to_a
    @group_by = params[:group_by]
    if @group_by == 'date'
      @grouped_attendance_data = @attendance_data_all.group_by {|attendance_data| attendance_data['date']}
    else
      @grouped_attendance_data = @attendance_data_all.group_by {|attendance_data| attendance_data['employee'].name }
    end

    respond_to do |format|
      format.html
      format.xls {
        if params[:attendance_register] == 'true'
          render 'attendance_register.xls'
        end
      }
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
    @start_date = get_start_date
    @end_date = get_end_date

    if @end_date < @start_date
      flash[:error] = "End Date has to be later than Start Date"
      @start_date = Time.zone.now
      @end_date = Time.zone.now
    end
    if @end_date.midnight > Time.zone.now.midnight
      flash[:error] = "End Date cannot be later than today"
      @start_date = Time.zone.now
      @end_date = Time.zone.now
    end

    @attendance_data_for = Hash.new
    (@start_date.to_date..(@end_date.midnight).to_date).each do |date|
      @attendance_data_for[date.strftime("%d-%m-%Y")] = @employee.attendance_data_for(date)
    end    
    @employees = current_user.employees
    @employee_code_enabled = @employee.store.employee_code_enabled
    @employee_designation_enabled = @employee.store.employee_designation_enabled
    @dates_all = (@start_date.to_date..(@end_date.midnight).to_date).to_a
    @dates_paginated = Kaminari.paginate_array(@dates_all).page(params[:page]).per(30)
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
    unless current_user.can('access_employee',params[:employee])
      render :status => :unauthorized
      return
    end
    employee_id = params[:employee]
    @employee = User.find(employee_id)
    @store = current_user.store
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

  def edit_employee
    unless current_user.can('access_employee',params[:employee_id])
      render :status => :unauthorized
      return
    end     
    @employee = User.find(params[:employee_id])         
    @employee_code_enabled = @employee.store.employee_code_enabled
    @employee_designation_enabled = @employee.store.employee_designation_enabled
    
  end

  def update_employee
    if current_user.can('access_employee',employee_params[:id])
      @employee = User.find(employee_params[:id])    
      if @employee.update(employee_params)
        redirect_to dashboard_employees_path
      else
        flash[:error] = "Could not save data"
        render "edit_employee"
      end
    else
      render :status => :unauthorized
      return
    end
  end

  private
  def get_start_date
    if params[:time_period_start].blank?
      start_date = Time.zone.now
    else
      start_date = DateTime.strptime(params[:time_period_start]+' +05:30', '%d-%m-%Y %z')
    end
    return start_date
  end
  def get_end_date
    if params[:time_period_end].blank?
      end_date = Time.zone.now
    else
      end_date = DateTime.strptime(params[:time_period_end]+' +05:30', '%d-%m-%Y %z')
    end
    return end_date
  end
  def get_date
    if params[:date].blank?      
      date = Time.zone.now
    else      
      date = DateTime.strptime(params[:date]+' +05:30', '%d-%m-%Y %z')
    end
    return date
  end
  def employee_params
    params.require(:employee).permit(:id,:name, :employee_code, :employee_designation, :employee_status, :store)
  end
end
