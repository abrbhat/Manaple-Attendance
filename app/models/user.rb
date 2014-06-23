class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :authorizations
  has_many :photos
  has_many :leaves
  before_save :ensure_authentication_token!
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
  def is_store_observer?
    if authorizations.present?
      return authorizations.first.permission == 'observer'
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

  def can(permission)
    allowed = false
    case permission
    when 'view_attendance_data'
      allowed = true if is_store_incharge? or is_store_observer?
    when 'modify_store_data'  
      allowed = true if is_store_incharge?
    when 'modify_profile_settings'
      allowed = true if is_store_incharge? or is_store_observer?      
    end
    return allowed
  end

  def accessible_in
    accessible_in = {}
    accessible_in["dashboard"] = []
    accessible_in["leaves"] = []
    accessible_in["pages"] = []
    accessible_in["photos"] = []
    accessible_in["api"] = []
    if is_store_incharge?
      accessible_in["dashboard"] <<  "notification_settings"
      accessible_in["dashboard"] <<  "notification_settings_update"
      accessible_in["dashboard"] <<  "employees"
      accessible_in["dashboard"] <<  "attendance_specific_day"
      accessible_in["dashboard"] <<  "attendance_time_period_consolidated"
      accessible_in["dashboard"] <<  "attendance_time_period_detailed"
      accessible_in["dashboard"] <<  "employee_attendance_record"
      accessible_in["dashboard"] <<  "create_employee"
      accessible_in["dashboard"] <<  "create_new_employee"
      accessible_in["leaves"] << "index"
      accessible_in["leaves"] << "update"
    elsif is_store_common_user?
      accessible_in["dashboard"] << "request_leave"
      accessible_in["dashboard"] << "choose_employee_name"
      accessible_in["dashboard"] << "choose_attendance_description"
      accessible_in["dashboard"] <<  "attendance_specific_day"
      accessible_in["dashboard"] <<  "attendance_time_period"

      accessible_in["leaves"] << "create"
      accessible_in["leaves"] << "apply"

      accessible_in["photos"] << "new"
      accessible_in["photos"] << "upload"
      accessible_in["photos"] << "create"

      accessible_in["api"] << "upload_attendance_data"
      accessible_in["api"] << "get_employee_data"
    elsif is_store_observer?
      accessible_in["dashboard"] <<  "notification_settings"
      accessible_in["dashboard"] <<  "notification_settings_update"
      accessible_in["dashboard"] <<  "employees"
      accessible_in["dashboard"] <<  "attendance_specific_day"
      accessible_in["dashboard"] <<  "attendance_time_period_consolidated"
      accessible_in["dashboard"] <<  "attendance_time_period_detailed"
      accessible_in["dashboard"] <<  "employee_attendance_record"
    else
      accessible_in["dashboard"] = []
    end
    return accessible_in
  end
  def home_path
    if is_store_incharge? or is_store_observer?
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

  def photos_for(date)
    photos.where(created_at: date.midnight..date.midnight + 1.day)
  end

  def attendance_data_for(date)
    attendance_data = Hash.new    
    attendance_data["date"] = date.strftime("%d-%m-%Y")
    attendance_data["employee"] = self
    attendance_data["status"] = "absent"
    attendance_data["in_time"] = nil
    attendance_data["in_status"] = nil
    attendance_data["in_photo"] = nil
    attendance_data["out_time"] = nil
    attendance_data["out_status"] = nil
    attendance_data["out_photo"] = nil
    
    photos_for_date = self.photos_for(date)
    in_photos = photos_for_date.select {|photo| photo.description=="in"}
    out_photos = photos_for_date.select {|photo| photo.description=="out"}
    if in_photos.present?
      attendance_data["in_photo"] = in_photos.last
      attendance_data["in_time"] = attendance_data["in_photo"].created_at.strftime("%I:%M%p")
      attendance_data["in_status"] = attendance_data["in_photo"].status
      if attendance_data["in_photo"].status != 'verification_rejected'
        attendance_data["status"] = "present"
      end
    end
    if out_photos.present?
      attendance_data["out_photo"] = out_photos.last
      attendance_data["out_time"] = attendance_data["out_photo"].created_at.strftime("%I:%M%p")
      attendance_data["out_status"] = attendance_data["out_photo"].status
      if attendance_data["out_photo"].status != 'verification_rejected'
        attendance_data["status"] = "present"
      end
    end
    if attendance_data["in_time"].blank? and attendance_data["out_time"].blank?
      if self.is_on_leave_on?(date.to_date)
        attendance_data["status"] = "on_leave"
      else
        attendance_data["status"] = "absent"
      end
    end
    return attendance_data
  end

  
  def generate_secure_token_string
    SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
  end

  # Sarbanes-Oxley Compliance: http://en.wikipedia.org/wiki/Sarbanes%E2%80%93Oxley_Act
  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W]).+/)
      errors.add :password, "must include at least one of each: lowercase letter, uppercase letter, numeric digit, special character."
    end
  end

  def password_presence
    password.present? && password_confirmation.present?
  end

  def password_match
    password == password_confirmation
  end

  def ensure_authentication_token!
    unless authentication_token.present?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = generate_secure_token_string
      break token unless User.where(authentication_token: token).first
    end
  end

  def reset_authentication_token!
    self.authentication_token = generate_authentication_token
  end
end
