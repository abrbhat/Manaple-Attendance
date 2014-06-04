class AddReasonToLeave < ActiveRecord::Migration
  def change
  	 add_column :leaves, :reason, :string
  end
end
