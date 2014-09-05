ActiveAdmin.register User do
  config.per_page = 10
  permit_params :email, :password, :password_confirmation, :name, :employee_code, :employee_designation, :employee_status, :category

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :employee_code
    column :employee_designation
    column :employee_status
    column :category  
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :name
      f.input :employee_code
      f.input :employee_status
      f.input :employee_designation
      f.input :password
      f.input :password_confirmation
      f.input :category
    end
    f.actions
  end

end
