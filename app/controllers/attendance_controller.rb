class AttendanceController < ApplicationController
  before_filter :authenticate_user!
  def mark
  	@store = current_user.store
    @employees = @store.employees + @store.asm
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
