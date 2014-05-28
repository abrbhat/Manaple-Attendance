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
end
