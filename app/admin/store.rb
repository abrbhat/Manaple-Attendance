ActiveAdmin.register Store do

  permit_params :name, :email, :phone, :in_out_enabled, :mid_day_enabled, :mid_day_in_out_enabled, :employee_code_enabled,:transfers_enabled,:leaves_enabled, :employee_designation_enabled, :store_opening_mail_enabled, :in_time_start, :in_time_end, :out_time_start, :out_time_end
  index do
    selectable_column
    id_column
    column :email
    column :name
    column :phone
    column :in_out_enabled
    column :mid_day_enabled
    column :mid_day_in_out_enabled
    column :employee_code_enabled
    column :transfers_enabled
    column :leaves_enabled
    column :employee_designation_enabled
    column :store_opening_mail_enabled
    column :in_time_start
    column :in_time_end
    column :out_time_start
    column :out_time_end
    actions
  end

 remove_filter :in_time_start
 remove_filter :in_time_end
 remove_filter :out_time_start
 remove_filter :out_time_end

  form do |f|
    f.inputs "Store Details" do
      f.input :email
      f.input :name
      f.input :phone
      f.input :in_out_enabled
      f.input :mid_day_enabled
      f.input :mid_day_in_out_enabled
      f.input :employee_code_enabled
      f.input :transfers_enabled
      f.input :leaves_enabled
      f.input :employee_designation_enabled
      f.input :store_opening_mail_enabled
      f.input :in_time_start
      f.input :in_time_end
      f.input :out_time_start
      f.input :out_time_end
    end
    f.actions
  end
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
