class AttendanceController < ApplicationController
  def mark
  	@store = current_user.store
    @employees = @store.employees
  end

  def record
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
end