class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
  end
  def notifications
  end
  def employees
  end
  def attendance_today
  	@stores = current_user.stores
  	@stores.each do |store|
  		
  	end
  end
end
