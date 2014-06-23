class AddMidDayInOutEnabledToStores < ActiveRecord::Migration
  def change
    add_column :stores, :mid_day_in_out_enabled, :boolean
  end
end
