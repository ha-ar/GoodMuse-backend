class CreateGoingStatuses < ActiveRecord::Migration[5.0]
	def change
		create_table :going_statuses do |t|
			t.integer :event_id
			t.integer :user_id
			t.boolean :going_status

			t.timestamps
		end
	end
end
