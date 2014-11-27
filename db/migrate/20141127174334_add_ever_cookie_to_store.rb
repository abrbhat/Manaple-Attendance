class AddEverCookieToStore < ActiveRecord::Migration
  def change
  	add_column :stores, :is_evercookie_set, :boolean
  	add_column :stores, :evercookie_value, :boolean
  end
end
