class AddInOutEnabledToStores < ActiveRecord::Migration
  def change
    add_column :stores, :in_out_enabled, :boolean, default: true
  end
end
