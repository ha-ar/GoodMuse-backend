class UpdateIndexOnUsers < ActiveRecord::Migration[5.0]
	def up
		sql = 'DROP INDEX index_users_on_email'
		sql << ' ON users' if Rails.env == 'production'
		ActiveRecord::Base.connection.execute(sql)
	end
end
