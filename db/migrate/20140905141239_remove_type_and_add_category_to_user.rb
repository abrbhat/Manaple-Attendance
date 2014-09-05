class RemoveTypeAndAddCategoryToUser < ActiveRecord::Migration
  def change
  	remove_column :users, :type
  	add_column :users, :category, :string
  end
end
