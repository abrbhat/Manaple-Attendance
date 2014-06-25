class AddEmployeeCodeEnabledToStore < ActiveRecord::Migration
  def change
  	add_column :stores, :employee_code_enabled, :boolean
  end
end
