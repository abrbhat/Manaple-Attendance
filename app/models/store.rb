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

  def get_attendance_data_between start_date, end_date
    attendance_data_all = []
    all_employees = all_employees_between_dates(start_date,end_date)
    photos_between_dates = self.photos.select {|photo| photo.created_at >= start_date.midnight and photo.created_at <= end_date.midnight}
    photos_of_a_date = photos_between_dates.group_by {|photo| photo.created_at.strftime("%d-%m-%Y")}
    all_employees.each do |employee|
      dates = employee.dates_for_which_employee_was_in(self,start_date,end_date)
      dates.each do |date|
        employee_photos = photos_between_dates.select {|photo| photo.created_at.to_date == date and photo.user == employee}
        attendance_data = employee.get_attendance_data_from_photos(self,date,employee_photos)
        attendance_data_all << attendance_data
      end
    end
    return attendance_data_all    
  end

  def all_employees_between_dates start_date, end_date
    all_employees = []
    all_employees << self.employees
    away_transfers_between_dates = self.away_transfers.select {|transfer| transfer.date >= start_date.midnight and transfer.date <= end_date.midnight}
    away_transfers_between_dates.each do |transfer|
      all_employees << transfer.user
    end
    return all_employees.flatten
  end
end
