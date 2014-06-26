class Store < ActiveRecord::Base
  has_many :authorizations
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
end
