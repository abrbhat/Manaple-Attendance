class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :permission
      t.references :user, index: true
      t.references :store, index: true

      t.timestamps
    end
  end
end
