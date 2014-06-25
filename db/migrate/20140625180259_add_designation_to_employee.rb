class AddDesignationToEmployee < ActiveRecord::Migration
  def change
  	add_column :users, :employee_designation, :string
  end
end
