class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if current_user.is_store_incharge?
      dashboard_attendance_specific_day_path
    elsif current_user.is_store_common_user?
      dashboard_choose_employee_name_path     
    end    
  end    
  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end
end
