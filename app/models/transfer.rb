class Transfer < ActiveRecord::Base
	belongs_to :user
	belongs_to :from_store, :class_name => 'Store', :foreign_key => 'from_store_id'
  	belongs_to :to_store, :class_name => 'Store', :foreign_key => 'to_store_id'
  	def employee
  		self.user
  	end
end
