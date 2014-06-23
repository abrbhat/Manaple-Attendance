class ApplicationController < ActionController::Base
  include VerifyAuthorization
   protect_from_forgery with: :exception
  # In Rails 3.x:
  # skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  # In Rails 4.x:
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json'}

 
  protect_from_forgery
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :check_browser
  Time.zone = 'Kolkata'
  def after_sign_in_path_for(resource)
    if resource.class.name == "User"
      if current_user.is_store_incharge? or current_user.is_store_common_user? or current_user.is_store_observer?
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

  def check_browser
    if !(browser.chrome? or browser.firefox?)
      sign_out :user
      flash[:error] = "This site cannot be accessed by your browser. Please use Chrome or Firefox!"
      new_user_session_path
    end
  end

  def authenticate_user_from_token!
    user_email = request.headers["X-API-EMAIL"].presence
    user_auth_token = request.headers["X-API-TOKEN"].presence
    user = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, user_auth_token)
      sign_in(user, store: false)
    end
  end

end
