require "base64"
class ApiController < ApplicationController
	before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  	def upload_attendance_data
      attendance_data = params[:attendance_data]
      #logger.debug ("Attendance Data: #{attendance_data.inspect}")
      attendance_data.each do |index, data|
        store = current_user.store
        File.open(upload_path(store), 'wb') do |file|
          file.write Base64.decode64(data['photo_data'])
        end
        photo = Photo.new
        photo.description = data['description']
        photo.user_id = data['user_id']
        photo.image = File.new(upload_path(store))   
        photo.status = "verification_pending" 
        photo.ip = request.remote_ip
        if photo.save
          # AdminMailer.notification().deliver
          if photo.is_first_of_day
            AsmMailer.store_opened(store,photo.created_at).deliver
          end
        else
          render :json => {"data_saved"=>"true"}
        end
        if photo.original == nil
          original_photo = Photo.new
          original_photo.user_id = data['user_id']
          original_photo.image = File.new(upload_path(store))
          original_photo.status = "verified"
          original_photo.description = "original"
          original_photo.ip = request.remote_ip
          original_photo.save
        end       
      end

      respond_to do |format|
        format.json {render :json => {"data_saved"=>"true"}}
      end     	
  	end

  	def get_employee_data
  		logger.debug ("here i am ")
  		store = current_user.store
  		employee_data = {}
  		logger.debug ("#{store.inspect}")
  		store.employees.each do |employee|
  			employee_data[employee.id] = employee.name
  		end
  		respond_to do |format|
	      format.json { render :json => employee_data }
	    end  		
  	end

  	private

  	def upload_path store# is used in upload and create
    	File.join(Rails.root, 'tmp', store.name+'-photo.jpg')
  	end
end