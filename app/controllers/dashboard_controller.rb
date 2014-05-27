class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
  end
  def notification_settings
  end
  def employees
  end
  def attendance_today
  	@stores = current_user.stores
  	@attendance_data_today = []
  	@stores.each do |store|
  		store.employees.each do |employee|
        attendance_data = Hash.new
  			photos = employee.photos.where(created_at: (Time.now.midnight)..Time.now.midnight + 1.day)
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
  end
  def attendance_time_period
  end
end
