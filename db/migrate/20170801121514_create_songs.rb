class CreateSongs < ActiveRecord::Migration[5.0]
	def change
		create_table :songs do |t|
			t.string :name
			t.string :artist_name
			t.string :album

			t.timestamps
		end
	end
end
