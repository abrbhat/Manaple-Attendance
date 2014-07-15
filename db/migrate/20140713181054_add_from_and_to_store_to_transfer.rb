class AddFromAndToStoreToTransfer < ActiveRecord::Migration
  def change
  	add_column :transfers, :from_store_id, :integer
  	add_index :transfers, :from_store_id
  	add_column :transfers, :to_store_id, :integer
  	add_index :transfers, :to_store_id
  end
end
