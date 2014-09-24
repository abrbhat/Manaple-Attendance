class VerificationController < ApplicationController
	before_filter :check_if_admin_signed_in? , :only => [:mass_verify, :do_mass_verification]
	before_filter :check_if_user_signed_in? , :only => [:verify, :do_verification]

	def mass_verify
		@photos = Photo.where("status = 'verification_pending'")
		@photos = @photos.select{|photo| photo.description != 'original'}
	end

	def do_mass_verification
		@verification_status = params[:verification_status]		
		@verification_status.each do |photo_id, status|
			photo = Photo.find(photo_id)
			photo.status = status
			photo.save
		end
		render text: "Verification Done"
	end

	def verify
		store_ids = current_user.authorizations.where(permission: 'verifier').pluck(:store_id)
		@photos = Photo.where(store_id: store_ids).where("status = 'verification_pending'")
		@photos = @photos.select{|photo| photo.description != 'original'}.first(50)
	end

	def do_verification
		@verification_status = params[:verification_status]		
		@verification_status.each do |photo_id, status|
			photo = Photo.find(photo_id)
			photo.status = status
			photo.save
		end
		render text: "Verification Done"
	end

	private
	def check_if_admin_signed_in?
		unless admin_user_signed_in?
			sign_out :user
      		flash[:error] = "You are not allowed there!"
      		redirect_to new_user_session_path	
		end
	end

	def check_if_user_signed_in?
		unless user_signed_in?
			sign_out :admin_user
      		flash[:error] = "You are not allowed there!"
      		redirect_to new_user_session_path	
		end
	end
end