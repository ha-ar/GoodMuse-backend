class AddGenreEventIdToEvents < ActiveRecord::Migration[5.0]
	def change
		add_column :events, :genre_event_id, :integer
	end
end
