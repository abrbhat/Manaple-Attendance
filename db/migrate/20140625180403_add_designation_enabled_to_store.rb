class AddDesignationEnabledToStore < ActiveRecord::Migration
  def change
  	add_column :stores, :employee_designation_enabled, :boolean
  end
end
