class AddRoleCheckToPlaylists < ActiveRecord::Migration[5.0]
	def change
		add_column :playlists, :is_dj, :boolean,  default: true
	end
end
