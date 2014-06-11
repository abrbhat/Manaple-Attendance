class Store < ActiveRecord::Base
  has_many :authorizations
  def employees
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

end
