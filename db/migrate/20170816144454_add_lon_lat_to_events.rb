class AddLonLatToEvents < ActiveRecord::Migration[5.0]
	def change
		add_column :events, :longitude, :string
		add_column :events, :latitude, :string

	end
end
