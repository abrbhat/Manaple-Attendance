class PhotosController < ApplicationController
  before_filter :authenticate_user!
  def create
    @photo = Photo.new(photo_params)
    @photo.image = File.new(upload_path)   
    @photo.status = "verification_pending" 
    @photo.save
    logger.debug "YoYO #{@photo.is_first_of_day.inspect}"
    if @photo.is_first_of_day

      #notify asm of store opening
    end
    render "dashboard/attendance_marked"
  end
  def new    
      @employee = User.find(params[:employee])
      @store = @employee.store
      @description = params[:description]
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def index
    @photos = Photo.all
  end

  def upload
    File.open(upload_path, 'wb') do |f|
      f.write request.raw_post
    end
    render :text => "ok"
  end

  private

  def photo_params
    params.require(:photo).permit(:description, :commit, :user_id)
  end

  def upload_path # is used in upload and create
    File.join(Rails.root, 'tmp', 'photo.jpg')
  end
end
