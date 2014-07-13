Rails.application.routes.draw do

  get 'employees/list'
  post 'employees/create'
  get 'employees/transfer'
  get 'employees/edit'
  get 'employees/new'
  post 'employees/update'
  post 'employees/update_store'

  get 'attendance/mark'
  get 'attendance/record'

  get 'pages/main'
  get 'pages/send_notification_mail'
  post 'pages/send_specific_day_notification_mail'
  get 'pages/send_mail'
  get 'pages/allot_stores'

  get 'dashboard/index'
  get 'dashboard/notification_settings'   
  get 'dashboard/notification_settings_view'
  post 'dashboard/notification_settings_update'

  get 'dashboard/attendance_specific_day'
  get 'dashboard/attendance_time_period_consolidated'
  get 'dashboard/attendance_time_period_detailed'
  get 'dashboard/employee_attendance_record'

  get 'verification/mass_verify'
  post 'verification/do_mass_verification'

  post 'api/upload_attendance_data'
  get 'api/get_employee_data'
  get 'api/get_attendance_markers'

  

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {sessions: "sessions"}
  resources :photos, :only => [:new, :create] do
    post 'upload', :on => :collection
  end
  resources :authorizations
  resources :leaves do
    get 'apply', on: :collection
  end
  root to: redirect("/dashboard/attendance_specific_day")

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
