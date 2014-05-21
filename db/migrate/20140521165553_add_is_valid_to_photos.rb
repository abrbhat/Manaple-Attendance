class AddIsValidToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :is_valid, :boolean
  end
end
