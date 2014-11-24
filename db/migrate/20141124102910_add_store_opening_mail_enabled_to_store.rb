class AddStoreOpeningMailEnabledToStore < ActiveRecord::Migration
  def change
  	add_column :stores, :in_time_start, :time
  	add_column :stores, :in_time_end, :time
  	add_column :stores, :out_time_start, :time
  	add_column :stores, :out_time_end, :time
  end
end
