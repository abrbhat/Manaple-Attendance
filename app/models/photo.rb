class Photo < ActiveRecord::Base
  belongs_to :user
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def is_first_of_day
  	store = user.store
  	today_photos = []  	
  	store.employees.each do |employee|
      if employee.photos.where(created_at: (Time.zone.now.midnight)..Time.zone.now.midnight + 1.day) != nil
    		employee.photos.where(created_at: (Time.zone.now.midnight)..Time.zone.now.midnight + 1.day).each do |photo|
          today_photos << photo.description
        end
  	  end
    end
  	if today_photos.count == 1
  		return true
  	else
  		return false
  	end
  end
end