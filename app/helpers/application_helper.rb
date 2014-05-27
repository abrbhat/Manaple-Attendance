module ApplicationHelper
	def is_active?(page_name)
		split_page_name =page_name.split('#')
		controller=split_page_name[0]
		action=split_page_name[1]
  		"present_location" if params[:action] == action && params[:controller] == controller
	end
end
