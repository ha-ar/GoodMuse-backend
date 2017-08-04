class CreateEvents < ActiveRecord::Migration[5.0]
	def change
		create_table :events do |t|
			
			t.string :name
			t.datetime :date
			t.string :venu_name
			t.string :address
			t.string :zip_code
			t.datetime :end_time
			t.string :price
			t.boolean :trainers_allowed
			t.string :upload_flyer
			t.string :playlist_tag
			
			t.timestamps
		end
	end
end
