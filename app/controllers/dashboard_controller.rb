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

  def master_settings
    unless current_user.is_master?
      render :status => :unauthorized
      return
    end
    store = current_user.stores.first
    @mid_day_enabled = store.mid_day_enabled
    @mid_day_in_out_enabled = store.mid_day_in_out_enabled
    @leaves_enabled = store.leaves_enabled
    @transfers_enabled = store.transfers_enabled
    @employee_code_enabled = store.employee_code_enabled
    @employee_designation_enabled = store.employee_designation_enabled
  end

  def master_settings_update
    unless current_user.is_master?
      render :status => :unauthorized
      return
    end
    current_user.stores.each do |store|
      store.update(store_params)
    end
    flash[:notice] = "Your settings have been saved"
    redirect_to dashboard_master_settings_path
  end

  def attendance_specific_day
    initialize_attendance_view
    @attendance_data_all = []
    @mid_day_enabled = false
    @mid_day_in_out_enabled = false
    @stores_to_display.each do |store|
      @mid_day_enabled = true if store.mid_day_enabled
      @mid_day_in_out_enabled = true if store.mid_day_in_out_enabled
      store.employees_eligible_for_attendance.each do |employee|  
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
    initialize_attendance_view    
    @attendance_data_all = get_attendance_data_for_stores(@stores_to_display, @start_date, @end_date, 'consolidated')
    @attendance_data_all.sort_by!{|attendance_data| [attendance_data['store'].name,attendance_data['employee'].name.capitalize]}
    @attendance_data_paginated = Kaminari.paginate_array(@attendance_data_all).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def attendance_time_period_detailed
    initialize_attendance_view    
    @attendance_data_all = get_attendance_data_for_stores(@stores_to_display, @start_date, @end_date, 'detailed')
    @attendance_data_all.sort_by!{|attendance_data| [attendance_data['date'],attendance_data['store'].name,attendance_data['employee'].name.capitalize]}
    @attendance_data_paginated = Kaminari.paginate_array(@attendance_data_all).page(params[:page]).per(30)
    @dates_all = (@start_date.to_date..(@end_date.midnight).to_date).to_a
    @group_by = params[:group_by]
    if @group_by == 'date'
      @grouped_attendance_data = @attendance_data_all.group_by {|attendance_data| attendance_data['date'].strftime("%d-%m-%Y")}
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
    initialize_attendance_view
    if params[:employee_id].blank?
      @employee = current_user.employees.first
    else
      unless current_user.can('access_employee',params[:employee_id])
        render :status => :unauthorized
        return
      end 
      @employee = User.find(params[:employee_id])
    end   

    @attendance_data_for = Hash.new
    (@start_date.to_date..(@end_date.midnight).to_date).each do |date|
      @attendance_data_for[date.strftime("%d-%m-%Y")] = @employee.attendance_data_for(date)
    end    
    
    @employees = current_user.employees_eligible_for_attendance
    @dates_all = (@start_date.to_date..(@end_date.midnight).to_date).to_a
    @dates_paginated = Kaminari.paginate_array(@dates_all).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.xls
    end
  end
 
  private
  def get_attendance_data_for_stores stores_array, start_date, end_date, type
    attendance_data_all = []
    stores_array.each do |store|
      attendance_data = store.get_attendance_data_between(start_date,end_date,type)
      attendance_data_all.concat attendance_data
    end
    return attendance_data_all
  end
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
  def initialize_attendance_view
    @all_stores = current_user.stores
    @stores_to_display = params[:stores].present? ? get_stores_to_display : @all_stores
    @employee_code_enabled = @all_stores.first.employee_code_enabled
    @employee_designation_enabled = @all_stores.first.employee_designation_enabled
    @start_date = get_start_date
    @end_date = get_end_date
    @date = get_date
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
    if @date.midnight > Time.zone.now.midnight
      flash[:error] = "Date cannot be later than today"
      @date = Time.zone.now
    end
  end

  def store_params
    params.require(:store).permit(:mid_day_enabled,:mid_day_in_out_enabled, :leaves_enabled, :employee_designation_enabled, :employee_code_enabled, :transfers_enabled)
  end

  
end
