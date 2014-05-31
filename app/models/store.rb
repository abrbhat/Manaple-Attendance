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

  def incharge
    authorizations.each do |authorization|
      if authorization.permission == 'asm' or authorization.permission == 'owner'
        return authorization.user
      end
    end
    return nil
  end
end
