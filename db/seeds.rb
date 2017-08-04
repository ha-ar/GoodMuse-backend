[:dj,:user].each do |role_name|
	role = Role.find_by(name: role_name)
	if role.blank?
		Role.create! name: role_name
		puts "Role Created"
	end
end