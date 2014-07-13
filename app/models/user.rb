class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :authorizations
  has_many :photos
  has_many :leaves
  has_many :transfers
  before_save :ensure_authentication_token!
  after_initialize :set_defaults
  include Rails.application.routes.url_helpers

  def self.mail_stores_attendance
    users = User.all
    users.each do |u|
      if u.is_store_asm? || u.is_store_owner?
        AsmMailer.notification(u).deliver
      end
    end
  end

  def self.mail_stores_specific_day_attendance(date)
    users = User.all
    users.each do |user|
      if user.is_store_asm? || user.is_store_owner?
        AsmMailer.specific_date_notification(user, date).deliver
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

  def can(permission,object_id = nil)
    allowed = false
    case permission
    when 'view_attendance_data'
      allowed = true if is_store_incharge? or is_store_observer?
    when 'modify_store_data'  
      allowed = true if is_store_incharge?
    when 'modify_profile_settings'
      allowed = true if is_store_incharge? or is_store_observer?   
    when 'access_employee_list'
      allowed = true if is_store_incharge? or is_store_observer?     
    when 'access_employee'
      employee = User.find(object_id)
      if employee.present?
        allowed = true if stores.include?(employee.store)
      end
    when 'access_store'
      store = Store.find(object_id)
      if store.present?
        allowed = true if stores.include?(store)
      end
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
    accessible_in["attendance"] = []
    accessible_in["employees"] = []

    if is_store_incharge?
      accessible_in["dashboard"] <<  "notification_settings"
      accessible_in["dashboard"] <<  "notification_settings_update"

      accessible_in["dashboard"] <<  "attendance_specific_day"
      accessible_in["dashboard"] <<  "attendance_time_period_consolidated"
      accessible_in["dashboard"] <<  "attendance_time_period_detailed"
      accessible_in["dashboard"] <<  "employee_attendance_record"

      accessible_in["leaves"] << "index"
      accessible_in["leaves"] << "update"

      accessible_in["employees"] << "create"
      accessible_in["employees"] << "edit"
      accessible_in["employees"] << "update"
      accessible_in["employees"] << "list"
      accessible_in["employees"] << "new"
      accessible_in["employees"] << "transfer"
      accessible_in["employees"] << "update_store"

    elsif is_store_common_user?
      accessible_in["dashboard"] << "request_leave"
      accessible_in["dashboard"] <<  "attendance_specific_day"
      accessible_in["dashboard"] <<  "attendance_time_period"
      
      accessible_in["attendance"] <<  "mark"
      accessible_in["attendance"] <<  "record"


      accessible_in["leaves"] << "create"
      accessible_in["leaves"] << "apply"

      accessible_in["photos"] << "upload"
      accessible_in["photos"] << "create"

      accessible_in["api"] << "upload_attendance_data"
      accessible_in["api"] << "get_employee_data"
      accessible_in["api"] << "get_attendance_data_markers"
    elsif is_store_observer?
      accessible_in["dashboard"] <<  "notification_settings"
      accessible_in["dashboard"] <<  "notification_settings_update"

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
      attendance_mark_path   
    else
      new_user_session_path
    end
  end
  def employees
    if can 'access_employee_list'
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
    attendance_data["mid_day_present_data"] = []
    attendance_data["mid_day_in_data"] = []
    attendance_data["mid_day_out_data"] = []

    attendance_data["mid_day_tabulated_data"] = "No Data" # Common for both mid day present and mid day in out
    
    photos_for_date = self.photos_for(date)
    in_photos = photos_for_date.select {|photo| photo.description=="in"}
    out_photos = photos_for_date.select {|photo| photo.description=="out"}
    mid_day_present_photos = photos_for_date.select {|photo| photo.description=="mid_day_present"}
    mid_day_in_photos = photos_for_date.select {|photo| photo.description=="mid_day_in"}
    mid_day_out_photos = photos_for_date.select {|photo| photo.description=="mid_day_out"}
    if in_photos.present?
      attendance_data["in_photo"] = in_photos.last
      attendance_data["in_status"] = attendance_data["in_photo"].status
      unless attendance_data["in_photo"].is_rejected?       
        attendance_data["in_time"] = attendance_data["in_photo"].created_at.strftime("%I:%M%p")
        attendance_data["status"] = "present"
      end
    end
    if out_photos.present?
      attendance_data["out_photo"] = out_photos.last
      attendance_data["out_status"] = attendance_data["out_photo"].status
      unless attendance_data["out_photo"].is_rejected?
        attendance_data["out_time"] = attendance_data["out_photo"].created_at.strftime("%I:%M%p")
        attendance_data["status"] = "present"
      end
    end
    if mid_day_present_photos.present?
      attendance_data["mid_day_tabulated_data"] = ""      
      mid_day_present_photos.each do |photo|
        mid_day_present_attendance_data = {}
        mid_day_present_attendance_data["time"] = photo.created_at.strftime("%I:%M%p")
        mid_day_present_attendance_data["status"] = photo.status
        data_string = mid_day_present_attendance_data["time"] 
        data_string += " : "
        data_string += mid_day_present_attendance_data["status"].tr('_', ' ').capitalize
        data_string += "<br/>"
        attendance_data["mid_day_tabulated_data"] << data_string
        attendance_data["mid_day_present_data"] << mid_day_present_attendance_data        
      end
    end
    if mid_day_in_photos.present? or mid_day_out_photos.present?
      attendance_data["mid_day_tabulated_data"] = ""
      in_data_string = "In :&nbsp;&nbsp;&nbsp;"
      out_data_string = "Out: "
      mid_day_in_photos.each do |photo|
        mid_day_in_attendance_data = {}
        mid_day_in_attendance_data["time"] = photo.created_at.strftime("%I:%M%p")
        mid_day_in_attendance_data["status"] = photo.status
        unless photo.is_rejected?          
          in_data_string += mid_day_in_attendance_data["time"] + "&nbsp;&nbsp;&nbsp;"
        end
        attendance_data["mid_day_in_data"] << mid_day_in_attendance_data 
      end
      mid_day_out_photos.each do |photo|
        mid_day_out_attendance_data = {}        
        mid_day_out_attendance_data["time"] = photo.created_at.strftime("%I:%M%p")
        mid_day_out_attendance_data["status"] = photo.status
        unless photo.is_rejected?
          out_data_string += mid_day_out_attendance_data["time"] + "&nbsp;&nbsp;&nbsp;"
        end
        attendance_data["mid_day_out_data"] << mid_day_out_attendance_data 
      end
      attendance_data["mid_day_tabulated_data"] << in_data_string + "<br>" + out_data_string             
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

  def set_defaults
    self.employee_status ||= 'active'    
  end

  def is_active?
    return self.employee_status == 'active'
  end

  def code
    return employee_code
  end

  def status
    return employee_status
  end

  def designation
    return employee_designation
  end
end
