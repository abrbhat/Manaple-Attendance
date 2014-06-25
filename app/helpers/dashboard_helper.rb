module DashboardHelper
	def attendance_marked_message employee, description, attendance_time
		message = ''
		message = employee.name 
		message += ", your '"
		message << description.capitalize
		message << "' attendance has already been marked for today at "
		message << attendance_time.strftime("%I:%M%p")
		message << "\n"
		message << "Do you want to mark your '"
		message << description
		message << "' attendance again? \n"
		message << "This will OVERWRITE previous data!"
		return message
	end
	def is_attendance_verified status
		if status == "verified"
			"status-positive-indicator"
		elsif status == "verification_pending"
			"status-neutral-indicator"
		elsif status == "verification_rejected"
			"status-negative-indicator"
		end
	end
	def is_present status
		if status == "present"
			"status-positive-indicator"		
		elsif status == "absent"
			"status-negative-indicator"
		elsif status == "on_leave"
			"status-neutral-indicator"
		end
	end

	def is_marked? attendance_time
		if attendance_time.present?
			return 'P'
		else
			return 'A'
		end
	end
end
