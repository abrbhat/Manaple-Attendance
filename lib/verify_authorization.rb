module VerifyAuthorization

  def self.included(base)
    base.before_filter :verify_authorization
  end

  def verify_authorization
  	if user_signed_in?
	    action = params[:action]
	    controller = params[:controller]
	    accessible_in = current_user.accessible_in
	    if accessible_in.has_key?(controller) and !accessible_in[controller].include? action
	      flash[:error] = 'You are not allowed there'
	      redirect_to current_user.home_path
	      return
	    end
	end
  end
end