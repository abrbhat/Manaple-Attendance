class PhotosController < ApplicationController
  def create
    @photo = Photo.new(photo_params)
    @photo.image = File.new(upload_path)
    @photo.save

    redirect_to @photo
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
    params.require(:photo).permit(:description, :commit)
  end

  def upload_path # is used in upload and create
    File.join(Rails.root, 'tmp', 'photo.jpg')
  end
end
