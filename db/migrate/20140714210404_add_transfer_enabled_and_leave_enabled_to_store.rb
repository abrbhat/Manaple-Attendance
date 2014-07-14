class AddTransferEnabledAndLeaveEnabledToStore < ActiveRecord::Migration
  def change
  	add_column :stores, :transfers_enabled, :boolean
  	add_column :stores, :leaves_enabled, :boolean
  end
end
