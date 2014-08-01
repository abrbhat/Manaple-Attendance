class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  has_attached_file :image, :styles => { :thumb => "100x100>" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def send_mails
    if is_first_of_day
      AsmMailer.store_opened(user.store,created_at).deliver
    end
  end

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

  def original
    original_photo = user.photos.where("description = 'original'")
    return original_photo.first
  end
  def is_rejected?
    status == "verification_rejected"
  end
  def is_not_rejected?
    (status == "verified" or status == "verification_pending")
  end
  def is_verified?
    status == "verified"
  end
  def is_pending_verification?
    status == "verification_pending"
  end
  def employee
    self.user
  end
end