class CorrectEvercookieValueInStore < ActiveRecord::Migration
  def change
  	remove_column :stores, :evercookie_value
  	add_column :stores, :evercookie_value, :string
  end
end
