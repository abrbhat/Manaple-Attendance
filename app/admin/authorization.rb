ActiveAdmin.register Authorization do

  config.per_page = 10

  permit_params :user_id, :store_id, :permission

  index do
    column :store
    column :user
    column :permission
    column :created_at
    column :updated_at
    actions
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
