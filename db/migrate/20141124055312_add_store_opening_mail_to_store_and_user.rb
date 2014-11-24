class AddStoreOpeningMailToStoreAndUser < ActiveRecord::Migration
  def change
  	add_column :users, :receive_store_opening_mail, :boolean
  	add_column :stores, :store_opening_mail_enabled, :boolean
  end
end
