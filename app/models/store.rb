class Store < ActiveRecord::Base
  has_many :authorizations
  has_many :photos
  has_many :away_transfers, :class_name => 'Transfer', :foreign_key => 'from_store_id'
  has_many :to_transfers, :class_name => 'Transfer', :foreign_key => 'to_store_id'
  after_initialize :set_defaults

  def employees #return only active enployees
  	employees = []
  	authorizations.each do |authorization|
  		if authorization.permission == 'staff' or authorization.permission == 'manager'
  			employees << authorization.user if authorization.user.is_active?
  		end
  	end
  	return employees
  end

  def all_employees
    employees = []
    authorizations.each do |authorization|
      if authorization.permission == 'staff' or authorization.permission == 'manager'
        employees << authorization.user
      end
    end
    return employees
  end

  def asm
    employees = []
    authorizations.each do |authorization|
      if authorization.permission == 'asm'
        employees << authorization.user if authorization.user.is_active?
      end
    end
    return employees    
  end

  def employees_eligible_for_attendance
    return self.employees + self.asm
  end

  def all_employees
    employees = []
    authorizations.each do |authorization|
      if authorization.permission == 'staff' or authorization.permission == 'manager' or authorization.permission == 'asm'
        employees << authorization.user
      end
    end
    return employees
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

  def incharges
    incharges = []
    authorizations.each do |authorization|
      if authorization.permission == 'asm' or authorization.permission == 'owner'
        incharges << authorization.user
      end
    end
    return incharges
  end

  def set_defaults
    self.in_out_enabled = true if self.in_out_enabled.nil?
    self.mid_day_enabled = false if self.mid_day_enabled.nil?
    self.mid_day_in_out_enabled = false if self.mid_day_in_out_enabled.nil?
    self.employee_code_enabled = false if self.employee_code_enabled.nil?
    self.employee_designation_enabled = false if self.employee_designation_enabled.nil?
  end

  def opening_time_on(date)
    photos_of_date = self.photos.select{|photo| photo.created_at >= date.midnight and photo.created_at <= (date.midnight + 1.day)}
    in_photos_of_date = photos_of_date.select {|photo| photo.description == 'in' and photo.status != 'verification_rejected'}
    first_photo_of_date = in_photos_of_date.min_by(&:created_at)
    return first_photo_of_date.created_at.strftime("%I:%M%p") if first_photo_of_date.present?
  end

  def closing_time_on(date)
    photos_of_date = self.photos.select{|photo| photo.created_at >= date.midnight and photo.created_at <= (date.midnight + 1.day)}
    out_photos_of_date = photos_of_date.select {|photo| photo.description == 'out' and photo.status != 'verification_rejected'}
    last_photo_of_date = out_photos_of_date.max_by(&:created_at)
    return last_photo_of_date.created_at.strftime("%I:%M%p") if last_photo_of_date.present?
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

  def employees_on date
    return self.all_employees_between_dates(date,date)
  end
end
