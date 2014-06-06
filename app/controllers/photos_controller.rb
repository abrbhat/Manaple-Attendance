require "base64"
class PhotosController < ApplicationController
  before_filter :authenticate_user!

  def create
    @photo = Photo.new(photo_params)
    @photo.image = File.new(upload_path(@photo.user.store))   
    @photo.status = "verification_pending" 
    @photo.ip = request.remote_ip
    if @photo.save
      AdminMailer.notification().deliver
      if @photo.is_first_of_day
        AsmMailer.store_opened(@photo.user.store,@photo.created_at).deliver
      end
    else
      flash[:error] = "There seems to be a network connection error."
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
    store = User.find(params[:photo_employee_id]).store
    File.open(upload_path(store), 'wb') do |f|
      f.write Base64.decode64(params[:photo_data])
    end
    render :text => "ok"
  end

  private

  def photo_params
    params.require(:photo).permit(:description, :commit, :user_id,:data)
  end

  def upload_path store# is used in upload and create
    File.join(Rails.root, 'tmp', store.name+'-photo.jpg')
  end
end
