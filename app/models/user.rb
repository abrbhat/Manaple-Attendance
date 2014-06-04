class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :authorizations
  has_many :photos
  has_many :leaves
  include Rails.application.routes.url_helpers

  def self.mail_stores_attendance
    users = User.all
    users.each do |u|
      if u.is_store_asm? || u.is_store_owner?
        AsmMailer.notification(u).deliver
      end
    end
  end

  def is_store_staff?
    if authorizations.present?
      return authorizations.first.permission == 'staff'
    end
  end
  def is_store_manager?
    if authorizations.present?
      return authorizations.first.permission == 'manager'
    end
  end
  def is_store_asm?
    if authorizations.present?
      return authorizations.first.permission == 'asm'
    end
  end
  def is_store_owner?
    # A Store Owner
    if authorizations.present?
      return authorizations.first.permission == 'owner'    
    end
  end
  def is_store_incharge?
    if authorizations.present?
      return ((authorizations.first.permission == 'asm') or (authorizations.first.permission == 'owner'))
    end
  end
  def is_store_common_user?
    if authorizations.present?
      return authorizations.first.permission == 'common_user'
    end
  end
  def stores
  	stores = []
  	authorizations.each do |authorization|
  		stores << authorization.store
  	end
  	return stores
  end
  def store
    stores = []
    authorizations.each do |authorization|
      stores << authorization.store
    end
    return stores.first
  end
  def accessible_in
    accessible_in = {}
    accessible_in["dashboard"] = []
    accessible_in["leaves"] = []
    accessible_in["pages"] = []
    accessible_in["photos"] = []
    if is_store_incharge?
      accessible_in["dashboard"] <<  "notification_settings"
      accessible_in["dashboard"] <<  "notification_settings_update"
      accessible_in["dashboard"] <<  "employees"
      accessible_in["dashboard"] <<  "attendance_specific_day"
      accessible_in["dashboard"] <<  "attendance_time_period"
      accessible_in["dashboard"] <<  "employee_attendance_record"
      accessible_in["dashboard"] <<  "create_employee"
      accessible_in["dashboard"] <<  "create_new_employee"
      accessible_in["leaves"] << "index"
      accessible_in["leaves"] << "update"
    elsif is_store_common_user?
      accessible_in["dashboard"] << "request_leave"
      accessible_in["dashboard"] << "choose_employee_name"
      accessible_in["dashboard"] << "choose_attendance_description"

      accessible_in["leaves"] << "create"
      accessible_in["leaves"] << "apply"

      accessible_in["photos"] << "new"
      accessible_in["photos"] << "upload"
      accessible_in["photos"] << "create"
    else
      accessible_in["dashboard"] = []
    end
    return accessible_in
  end
  def home_path
    if is_store_incharge?
      dashboard_attendance_specific_day_path
    elsif is_store_common_user?
      dashboard_choose_employee_name_path   
    else
      new_user_session_path
    end
  end
  def employees
    if is_store_incharge?
      employees =[]
      stores.each do |store|
        employees << store.employees
      end
      return employees.flatten
    end     
  end
  def is_on_leave_on?(date)
    leaves_including_date = leaves.where("start_date <= :date AND end_date >= :date AND status = 'approved'",{date: date}) 
    if leaves_including_date.present?
      return true
    else
      return false
    end
  end
end
