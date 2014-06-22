ActiveAdmin.register Photo do

  config.per_page = 5

  permit_params :description, :image_file_name, :image_content_type, :image_file_size, :image_updated_at, :status, :ip

  index do
    column :description
    column :user
    column :created_at
    column :image_updated_at
    column :status
    column :ip
    column :image do |photo|
      image_tag photo.image.url(:medium)
    end
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
