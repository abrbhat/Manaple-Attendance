class AddStoreIdToPhotos < ActiveRecord::Migration
  def change
  	add_column :photos, :store_id, :integer
  	add_index :photos, :store_id
  end
end
