class AddMidDayEnabledToStores < ActiveRecord::Migration
  def change
    add_column :stores, :mid_day_enabled, :boolean
  end
end
