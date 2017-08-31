class AddGcmKeyToUser < ActiveRecord::Migration[5.0]
	def change
		add_column :users, :fcm_key, :string
	end
end
