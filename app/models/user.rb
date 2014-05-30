class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :authorizations
  has_many :photos

  def self.mail_stores_attendance
    users = User.all
    users.each do |u|
      if u.is_store_asm?
        AsmMailer.notification(u).deliver
      end
    end
  end

  def is_store_staff?
    if authorizations.present?
      return authorizations.first.permission == 'staff'
    end
  end
  def is_store_manager?
    if authorizations.present?
      return authorizations.first.permission == 'manager'
    end
  end
  def is_store_asm?
    if authorizations.present?
      return authorizations.first.permission == 'asm'
    end
  end
  def is_store_owner?
    # A Store Owner
    if authorizations.present?
      return authorizations.first.permission == 'owner'    
    end
  end
  def is_store_incharge?
    if authorizations.present?
      return ((authorizations.first.permission == 'asm') or (authorizations.first.permission == 'owner'))
    end
  end
  def is_store_common_user?
    if authorizations.present?
      return authorizations.first.permission == 'common_user'
    end
  end
  def stores
  	stores = []
  	authorizations.each do |authorization|
  		stores << authorization.store
  	end
  	return stores
  end
  def store
    stores = []
    authorizations.each do |authorization|
      stores << authorization.store
    end
    return stores.first
  end
end
