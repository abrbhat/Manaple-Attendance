class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
  end
  def notification_settings
  end
  def employees
  end
  def attendance_specific_day
    @stores = current_user.stores
    @attendance_data_today = []
    @stores.each do |store|
      store.employees.each do |employee|
        attendance_data = Hash.new
        if params[:date].blank?
          photos = employee.photos.where(created_at: (Time.now.midnight)..Time.now.midnight + 1.day)
          @date = Time.now.strftime("%d-%m-%Y")
        else
          photos = employee.photos.where(created_at: (DateTime.parse(params[:date]).midnight)..DateTime.parse(params[:date]).midnight + 1.day)
          @date = params[:date]
        end
        photos.each do |photo|
          if photo.description == 'in'          
            attendance_data["in_time"] = photo.updated_at.strftime("%I:%M%p")
          end
          if photo.description == 'out'          
            attendance_data["out_time"] = photo.updated_at.strftime("%I:%M%p")
          end
        end
        attendance_data["employee"] = employee
        @attendance_data_today << attendance_data
      end
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end
  def attendance_time_period
    @stores = current_user.stores
    @attendance_data_today = []
    @stores.each do |store|
      store.employees.each do |employee|
        attendance_data = Hash.new
        attendance_data["present_count"] = 0
        if params[:time_period_start].blank?
          @start_date = Time.now
          @end_date = Time.now
          @date = Time.now.strftime("%d-%m-%Y")
        else
          @start_date = DateTime.parse(params[:time_period_start])
          @end_date = DateTime.parse(params[:time_period_end])
          @date = params[:date]
        end
        photos = employee.photos.where(created_at: (@start_date.midnight..@end_date.midnight + 1.day))
        photos.each do |photo|
          if photo.description == 'in'          
            attendance_data["present_count"] = attendance_data["present_count"] + 1
          end
        end
        @working_days = (@end_date-@start_date).to_i + 1
        attendance_data["absent_count"] = @working_days - attendance_data["present_count"]
        attendance_data["employee"] = employee
        @attendance_data_today << attendance_data
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
end
