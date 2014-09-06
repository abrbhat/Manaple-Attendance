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

  def self.mail_stores_specific_day_attendance(date)
    users = User.all
    users.each do |user|
      if user.should_receive_daily_attendance_notification_mail?
        AsmMailer.delay.specific_date_notification(user, date)
      end
    end
  end
  def mail_stores_specific_day_attendance_specific_user(date)
    if self.should_receive_daily_attendance_notification_mail?
      AsmMailer.specific_date_notification(self, date).deliver
    end
  end
  # Fundamental Employee Hierarchy Deciding Functions: 
  def is_store_staff?
    return authorizations.exists?(:permission => 'staff')
  end
  def is_store_manager?
    return authorizations.exists?(:permission => 'manager')
  end
  def is_store_asm?
    # Incharge who has to mark attendance too, unlike supervisor or owner
    return authorizations.exists?(:permission => 'asm')
  end
  def is_store_owner?
    return authorizations.exists?(:permission => 'owner')
  end
  def is_store_supervisor?
    # Incharge who is not owner
    return authorizations.exists?(:permission => 'supervisor')
  end
  def is_store_common_user?
    return authorizations.exists?(:permission => 'common_user')
  end
  def is_store_observer?
    return authorizations.exists?(:permission => 'observer')
  end  

  def is_account_manager?
    return (category == "account_manager")
  end

  def is_master?
    is_master = false
    if self.authorizations.present? and self.authorizations.select{|authorization| authorization.permission != "master"}.blank?
      is_master = true      
    end
    return is_master
  end

  #Inheriting Hierarchy Deciding Functions
  def is_store_incharge?
    return (self.is_store_owner? or self.is_store_asm? or self.is_store_supervisor?)
  end
  def is_eligible_for_attendance?
    return (self.is_store_staff? or self.is_store_asm? or self.is_store_manager?)
  end
  
  def should_receive_store_opening_mail?
  	return (self.is_store_incharge? or self.is_store_observer?	)
  end
  
  def should_receive_daily_attendance_notification_mail?
  	return (self.is_store_incharge? or self.is_store_observer?)	
  end

  #Store specific hierarchy-deciding functions
  def is_store_staff_of store
    return authorizations.exists?(:permission => 'staff', :store_id => store.id)
  end
  def is_store_manager_of store
    return authorizations.exists?(:permission => 'manager', :store_id => store.id)
  end
  def is_store_asm_of store
    # Incharge who has to mark attendance too, unlike supervisor or owner
    return authorizations.exists?(:permission => 'asm', :store_id => store.id)
  end
  def is_store_owner_of store
    return authorizations.exists?(:permission => 'owner', :store_id => store.id)
  end
  def is_store_supervisor_of store
    # Incharge who is not owner
    return authorizations.exists?(:permission => 'supervisor', :store_id => store.id)
  end
  def is_store_common_user_of store
    return authorizations.exists?(:permission => 'common_user', :store_id => store.id)
  end
  def is_store_observer_of store
    return authorizations.exists?(:permission => 'observer', :store_id => store.id)
  end  
  def is_master_of store
    is_master = false
    self.authorizations.each do |authorization|
      if authorization.permission == "master" and authorization.store == store
        is_master = true
      end
    end
    return is_master
  end

  def is_store_incharge_of store
    return (self.is_store_owner_of(store) or self.is_store_asm_of(store) or self.is_store_supervisor_of(store))
  end
  def is_eligible_for_attendance_in store
    return (self.is_store_staff_of(store) or self.is_store_asm_of(store) or self.is_store_manager_of(store))
  end
  
  def should_receive_store_opening_mail_for store
    return (self.is_store_incharge_of(store) or self.is_store_observer_of(store)  )
  end
  
  def should_receive_daily_attendance_notification_mail_for store
    return (self.is_store_incharge_of(store) or self.is_store_observer_of(store)) 
  end

  def stores
  	stores = []
    if is_account_manager?
      stores = Store.all
    else
    	authorizations.each do |authorization|
    		stores << authorization.store
    	end
    end
  	return stores.uniq
  end
  def store    
    return self.stores.first
  end

  def can(permission,object_id = nil)
    allowed = false
    case permission     
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
    else      
      permissions = []
      if self.is_store_incharge? 
        permissions << 'view_attendance_data'
        permissions << 'modify_store_data'  
        permissions << 'modify_profile_settings'
        permissions << 'access_employee_list'
        permissions << 'approve_leaves'
      elsif self.is_store_observer?
        permissions << 'view_attendance_data'
        permissions << 'modify_profile_settings'
        permissions << 'access_employee_list'
      elsif self.is_store_common_user?
        permissions << 'mark_attendance'
      elsif self.is_account_manager?
        permissions << 'view_attendance_data'
        permissions << 'modify_store_data'  
        permissions << 'modify_profile_settings'
        permissions << 'access_employee_list'
        permissions << 'approve_leaves'
      end
      allowed = permissions.include? permission
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

      accessible_in["pages"] << "troubleshoot_webcam_error"
      accessible_in["pages"] << "download_amcap_setup"
    elsif is_store_observer?
      accessible_in["dashboard"] <<  "notification_settings"
      accessible_in["dashboard"] <<  "notification_settings_update"

      accessible_in["dashboard"] <<  "attendance_specific_day"
      accessible_in["dashboard"] <<  "attendance_time_period_consolidated"
      accessible_in["dashboard"] <<  "attendance_time_period_detailed"
      accessible_in["dashboard"] <<  "employee_attendance_record"
    elsif is_master?      
      accessible_in["dashboard"] <<  "master_settings"
      accessible_in["dashboard"] <<  "master_settings_update"
    elsif is_account_manager?
      accessible_in["pages"] <<  "enter_bulk_store_data"
      accessible_in["pages"] <<  "create_bulk_stores"

      accessible_in["pages"] <<  "select_bulk_authorizations_to_create"
      accessible_in["pages"] <<  "create_bulk_authorizations"

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
    elsif is_master?
      dashboard_master_settings_path
    elsif is_account_manager?
      pages_enter_bulk_store_data_path
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

  def is_eligible_for_attendance?
    if self.is_store_asm? or self.is_store_manager? or self.is_store_staff?
      true
    else
      false
    end
  end
  def attendance_data_for(date,store)    
    photos_for_date = self.photos_for(date)  
    if store.present?
      store_on_date = store
    else
      store_on_date = self.store_on date
    end
    photos_for_date_and_store = self.photos_for(date).select {|photo| photo.store == store_on_date}
    attendance_data = self.get_attendance_data_from_photos(store_on_date,date,photos_for_date_and_store)
    return attendance_data
  end

  def get_attendance_data_from_photos(store,date,photos_array)
    attendance_data = Hash.new    
    attendance_data["date"] = date
    attendance_data["employee"] = self
    attendance_data["status"] = "absent"
    attendance_data["store"] = store
    attendance_data["in_time"] = nil
    attendance_data["in_status"] = nil # In Photo Verification Status
    attendance_data["in_photo"] = nil
    attendance_data["in_attendance_status"] = nil
    attendance_data["out_time"] = nil
    attendance_data["out_status"] = nil
    attendance_data["out_photo"] = nil # Out Photo Verification Status
    attendance_data["out_attendance_status"] = nil
    attendance_data["mid_day_present_data"] = []
    attendance_data["mid_day_in_data"] = []
    attendance_data["mid_day_out_data"] = []

    attendance_data["mid_day_tabulated_data"] = "No Data" # Common for both mid day present and mid day in out
    
    in_photos = photos_array.select {|photo| photo.description=="in"}
    out_photos = photos_array.select {|photo| photo.description=="out"}
    mid_day_present_photos = photos_array.select {|photo| photo.description=="mid_day_present"}
    mid_day_in_photos = photos_array.select {|photo| photo.description=="mid_day_in"}
    mid_day_out_photos = photos_array.select {|photo| photo.description=="mid_day_out"}
    if in_photos.present?
      attendance_data["in_photo"] = in_photos.last
      attendance_data["in_status"] = attendance_data["in_photo"].status
      unless attendance_data["in_photo"].is_rejected?       
        attendance_data["in_time"] = attendance_data["in_photo"].created_at.strftime("%I:%M%p")
        attendance_data["status"] = "present"
        attendance_data["in_attendance_status"] = "present"
      end
      if attendance_data["store"].blank? 
        attendance_data["store"] = attendance_data["in_photo"].store
      end
    end
    if out_photos.present?
      attendance_data["out_photo"] = out_photos.last
      attendance_data["out_status"] = attendance_data["out_photo"].status
      unless attendance_data["out_photo"].is_rejected?
        attendance_data["out_time"] = attendance_data["out_photo"].created_at.strftime("%I:%M%p")
        attendance_data["status"] = "present"
        attendance_data["out_attendance_status"] = "present"
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
        attendance_data["in_attendance_status"] = "leave"
        attendance_data["out_attendance_status"] = "leave"
      else
        attendance_data["status"] = "absent"
      end
    end
    attendance_data["in_attendance_status"] = "absent" if attendance_data["in_attendance_status"].blank?
    attendance_data["out_attendance_status"] = "absent" if attendance_data["out_attendance_status"].blank?
    return attendance_data
  end

  def dates_for_which_employee_was_in(store,start_date,end_date)
    all_dates = (start_date.to_date..(end_date).to_date).to_a
    dates = []
    joining_transfers = self.transfers.select {|transfer| transfer.to_store == store }
    leaving_transfers = self.transfers.select {|transfer| transfer.from_store == store}
    joining_transfers.each do |joining_transfer|
      time_period = Hash.new
      time_period["begin"] = joining_transfer.date
      leaving_transfers_after_this_joining = leaving_transfers.select{|transfer| transfer.date > joining_transfer.date}
      if leaving_transfers_after_this_joining.blank?
        time_period["end"] = end_date
      else
        time_period["end"] = leaving_transfers_after_this_joining.min_by(&:date).date
      end
      time_period_dates = (time_period["begin"].to_date..(time_period["end"]).to_date).to_a
      dates = dates + time_period_dates
    end
    common_dates = all_dates & dates
    return common_dates
  end

  def store_on date
    last_transfer_before_date = self.transfers.select {|transfer| transfer.date < date}.max_by(&:date)
    if last_transfer_before_date.present?
      return last_transfer_before_date.to_store
    else
      return self.store
    end
  end

  def transfers_enabled?
    self.stores.first.transfers_enabled
  end

  def leaves_enabled?
    self.stores.first.leaves_enabled
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
