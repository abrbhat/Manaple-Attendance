class AddIpToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :ip, :string
  end
end
