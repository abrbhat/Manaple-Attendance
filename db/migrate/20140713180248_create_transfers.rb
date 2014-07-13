class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.date :date

      t.timestamps
    end
  end
end
