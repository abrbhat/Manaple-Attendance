class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
  end
  def notification_settings
  end
  def employees
  end
end
