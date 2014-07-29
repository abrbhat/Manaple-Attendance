class Store < ActiveRecord::Base
  has_many :authorizations
  has_many :photos
  has_many :away_transfers, :class_name => 'Transfer', :foreign_key => 'from_store_id'
  has_many :to_transfers, :class_name => 'Transfer', :foreign_key => 'to_store_id'
  after_initialize :set_defaults

  def employees #return only active staff and managers
  	employees = []
  	authorizations.each do |authorization|
      employee = authorization.user
      if (employee.is_store_staff? or employee.is_store_manager?) and employee.is_active?
          employees << employee
      end
    end
    return employees
  end

  def asm
    employees = []
    authorizations.each do |authorization|
      employee = authorization.user
      if employee.is_store_asm? and employee.is_active?
          employees << employee
      end
    end
    return employees  
  end

  def incharges
    incharges = []
    authorizations.each do |authorization|
      if authorization.user.is_store_incharge? and authorization.user.is_active?
        incharges << authorization.user
      end
    end
    return incharges
  end
  
  def observers
    incharges = []
    authorizations.each do |authorization|
      if authorization.user.is_store_observer?
        incharges << authorization.user
      end
    end
    return incharges
  end

  def inactive_employees
    employees = []
    authorizations.each do |authorization|
      employee = authorization.user
      if (employee.is_store_staff? or employee.is_store_manager?) and !employee.is_active?
          employees << employee
      end
    end
    return employees
  end

  def employees_currently_eligible_for_attendance
    return self.employees + self.asm
  end

  def employees_who_ever_marked_attendance
    employees = []
    self.to_transfers.each do |to_transfer|
      employees <<  to_transfer.employee
    end
    return employees
  end
	
	def users_who_should_receive_store_opening_mail
		return self.incharges + self.observers
	end
	
	def users_who_should_receive_leave_request_mail
		return self.incharges + self.observers
	end
	
  def leaves
    leaves = []
    employees.each do |employee|
      if employee.leaves.present?
        leaves << employee.leaves
      end
    end
    leaves.flatten!
    return leaves
  end

  def set_defaults
    self.in_out_enabled = true if self.in_out_enabled.nil?
    self.mid_day_enabled = false if self.mid_day_enabled.nil?
    self.mid_day_in_out_enabled = false if self.mid_day_in_out_enabled.nil?
    self.employee_code_enabled = false if self.employee_code_enabled.nil?
    self.employee_designation_enabled = false if self.employee_designation_enabled.nil?
  end

  def opening_time_on(date)
    attendance_data_for_date = self.attendance_data_for date
    first_data_for_date = attendance_data_for_date.select{|attendance_data| attendance_data["in_photo"].present? }.min_by{|attendance_data| attendance_data["in_photo"].created_at }    
    return first_data_for_date["in_time"] if first_data_for_date.present?
  end

  def closing_time_on(date)
    attendance_data_for_date = self.attendance_data_for date
    last_data_for_date = attendance_data_for_date.select{|attendance_data| attendance_data["out_photo"].present? }.max_by{|attendance_data| attendance_data["out_photo"].created_at }    
    return last_data_for_date["out_time"] if last_data_for_date.present?
  end

  def get_attendance_data_between start_date, end_date, type
    attendance_data_all = []
    attendance_count_data = []
    all_employees = all_employees_between_dates(start_date,end_date)
    photos_between_dates = self.photos.select {|photo| photo.created_at >= start_date.midnight and photo.created_at <= (end_date.midnight + 1.day)}
    photos_of_a_date = photos_between_dates.group_by {|photo| photo.created_at.strftime("%d-%m-%Y")}
    all_employees.each do |employee|
      attendance_count = Hash.new
      attendance_count["employee"] = employee
      attendance_count["store"] = self
      attendance_count["present_count"] = 0
      attendance_count["absent_count"] = 0
      attendance_count["leave_count"] = 0
      dates = employee.dates_for_which_employee_was_in(self,start_date,end_date)
      dates.each do |date|
        employee_photos = photos_between_dates.select {|photo| photo.created_at.to_date == date and photo.user == employee}
        attendance_data = employee.get_attendance_data_from_photos(self,date,employee_photos)
        attendance_data_all << attendance_data
        case attendance_data['status']
        when "present"
          attendance_count["present_count"] += 1
        when "absent"
          attendance_count["absent_count"] += 1
        when "on_leave"
          attendance_count["leave_count"] += 1
        end
      end
      attendance_count_data << attendance_count
    end
    if type == 'consolidated'
      return attendance_count_data
    else
      return attendance_data_all 
    end
  end

  def all_employees_between_dates start_date, end_date   
    all_employees = []    
    self.to_transfers.each do |transfer|
      if transfer.user.dates_for_which_employee_was_in(self,start_date,end_date).present?
        all_employees << transfer.user
      end
    end
    return all_employees.uniq
  end

  def attendance_data_for date
    attendance_data_all = []
    employees_to_display = self.employees_on(date)
    employees_to_display.each do |employee|  
      attendance_data = employee.attendance_data_for(date,self)
      attendance_data_all << attendance_data
    end
    return attendance_data_all.flatten
  end
  def employees_on date
    return self.all_employees_between_dates(date,date)
  end
end