class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
      t.string :status
      t.date :start_date
      t.date :end_date
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
