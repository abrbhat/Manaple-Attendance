module LeavesHelper
	def is_leave_approved status
		if status == "approved"
			"status-positive-indicator"
		elsif status == "decision_pending"
			"status-neutral-indicator"
		elsif status == "rejected"
			"status-negative-indicator"
		end
	end

	
end
