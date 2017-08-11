class CreateEventsPlaylists < ActiveRecord::Migration[5.0]

	def change
		create_table :events_playlists do |t|
			t.integer :event_id
			t.integer :playlist_id

			t.timestamps
		end
	end
end