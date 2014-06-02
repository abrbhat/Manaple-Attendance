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
  def can_access
    if is_store_incharge?
      ["dashboard/view_leave_requests","dashboard/notification_settings","dashboard/notification_settings_update","dashboard/employees","dashboard/attendance_specific_day","dashboard/attendance_time_period","dashboard/employee_attendance_record"]
    elsif is_store_common_user?
      ["dashboard/request_leave","dashboard/choose_employee_name","dashboard/choose_attendance_description"]
    else
      []
    end
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
end
