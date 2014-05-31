class Users::RegistrationsController < Devise::RegistrationsController
	protected
	def sign_up(resource_name, resource)

  	end

  	def after_sign_up_path_for(resource)
    	sign_out :user
      	flash[:error] = resource.name+", "+resource.email+" has been created!"
      	new_user_session_path
  	end
  	protected

end