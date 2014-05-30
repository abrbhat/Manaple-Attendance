module DashboardHelper
	def attendance_marked_message employee, description, attendance_time
		message = employee.name 
		message << ", your "
		message << description.capitalize
		message << " attendance has already been marked for today at "
		message << attendance_time.strftime("%I:%M%p")
		message << "\n"
		message << "Do you want to mark your "
		message << description
		message << " attendance again? \n"
		message << "This will OVERWRITE previous data!"
	end
	def is_attendance_verified status
		if status == "Verified"
			"verified-indicator"
		else
			"not-verified-indicator"
		end
	end
end
