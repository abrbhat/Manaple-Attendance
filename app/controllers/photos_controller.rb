require "base64"
class PhotosController < ApplicationController
  before_filter :authenticate_user!

  def create
    @photo = Photo.new(photo_params)
    @photo.image = File.new(upload_path)   
    @photo.status = "verification_pending" 
    @photo.save
    if @photo.is_first_of_day
      AsmMailer.store_opened(user.store).deliver
    end
    render "dashboard/attendance_marked"
  end
  def new   
    if params[:employee].blank?
      sign_out :user
      flash[:error] = "You are not allowed there."
      redirect_to new_user_session_path
    end 
      @employee = User.find(params[:employee])
      @store = @employee.store
      @description = params[:description]
  end

  def upload
    File.open(upload_path, 'wb') do |f|
      f.write Base64.decode64(params[:photo_data])
    end
    render :text => "ok"
  end

  private

  def photo_params
    params.require(:photo).permit(:description, :commit, :user_id,:data)
  end

  def upload_path # is used in upload and create
    File.join(Rails.root, 'tmp', 'photo.jpg')
  end
  def verify_authorization
    action = params[:action]
    unless current_user.can_access.include? ("photos/"+action) 
      flash[:error] = 'You are not allowed there'
      redirect_to current_user.home_path
    end
  end
end
