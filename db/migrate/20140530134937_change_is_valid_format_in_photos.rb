class ChangeIsValidFormatInPhotos < ActiveRecord::Migration
  def change
  	remove_column :photos, :is_valid
  end
end
