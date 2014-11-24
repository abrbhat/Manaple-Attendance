ActiveAdmin.register User do
  config.per_page = 10
  permit_params :email, :password, :password_confirmation, :name, :employee_code, :employee_designation, :employee_status, :category, :receive_store_opening_mail

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
    column :receive_store_opening_mail
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
      f.input :receive_store_opening_mail
    end
    f.actions
  end

  controller do
    def update
      user = params["user"]

      # If we haven't set a password explicitly, we don't want it reset so 
      # don't pass those fields upstream and devise will ignore them
      if user && (user["password"] == nil || user["password"].empty?)
        user.delete("password")
        user.delete("password_confirmation")
      end

      update!
    end
  end

end
