ActiveAdmin.register Store do

  permit_params :name, :email, :phone, :in_out_enabled, :mid_day_enabled, :mid_day_in_out_enabled, :employee_code_enabled,:transfers_enabled,:leaves_enabled, :employee_designation_enabled
  
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
