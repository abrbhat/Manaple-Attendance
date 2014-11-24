class AttendanceController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_evercookie!
  def mark
  	@store = current_user.store
    @employees = @store.employees_currently_eligible_for_attendance
    @in_attendance_marking_available = false
    @out_attendance_marking_available = false

    current_time = Time.zone.now.strftime( "%H%M%S%N" )
    @in_time_start = @store.in_time_start
    @in_time_end = @store.in_time_end
    @out_time_start = @store.out_time_start
    @out_time_end = @store.out_time_end

    if current_time >= @in_time_start.strftime( "%H%M%S%N" ) and current_time <= @in_time_end.strftime( "%H%M%S%N" )
      @in_attendance_marking_available = true
    end

    if current_time >= @out_time_start.strftime( "%H%M%S%N" ) and current_time <= @out_time_end.strftime( "%H%M%S%N" )
      @out_attendance_marking_available = true
    end
  end

  def choose_attendance_description
    unless current_user.can('access_employee',params[:employee])
      render :status => :unauthorized
      return
    end
    employee_id = params[:employee]
    @employee = User.find(employee_id)
    @store = current_user.store
    
  end

  def marked_status
    
  end

  private

  def check_evercookie!
    store = current_user.store
    if store.is_evercookie_set
      unless cookies.signed[:evercookie_value] and (cookies.signed[:evercookie_value] == store.evercookie_value)        
        sign_out :user
        flash[:error] = "You are not authorized to access this account from this PC. Contact at helpline@manaple.com"
        redirect_to new_user_session_path
      end
    else  
      #No Evercookie set. Could be first login. Set Evercookie and Login
      cookies.permanent.signed[:evercookie_value] = current_user.store.evercookie_value
      store.is_evercookie_set = true
      store.save
    end      
  end
end
