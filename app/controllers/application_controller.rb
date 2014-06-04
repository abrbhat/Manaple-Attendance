class ApplicationController < ActionController::Base
  include VerifyAuthorization
  protect_from_forgery
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  Time.zone = 'Kolkata'
  def after_sign_in_path_for(resource)
    if resource.class.name == "User"
      if current_user.is_store_incharge? or current_user.is_store_common_user?
        current_user.home_path
      elsif !admin_user_signed_in?
        sign_out :user
        flash[:error] = "You are not allowed there."
        new_user_session_path
      end
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
