class AddEmployeeCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :employee_code, :string
  end
end
