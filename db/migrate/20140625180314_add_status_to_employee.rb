class AddStatusToEmployee < ActiveRecord::Migration
  def change
  	add_column :users, :employee_status, :string
  end
end
