class AddIndexToPhotos < ActiveRecord::Migration
  def change
    add_index :photos, :description
  end
end
