class RemoveSongIdFromTags < ActiveRecord::Migration[5.0]
	def change
		remove_column :tags, :song_id
	end
end
