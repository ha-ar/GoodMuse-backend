[:dj,:user].each do |role_name|
	role = Role.find_by(name: role_name)
	if role.blank?
		Role.create! name: role_name
		puts "Role Created"
	end
end

user = User.create(first_name: "test", last_name: "test", username: "tester", email: "test@goodmuse.com", password: "11111111", password_confirmation: "11111111")
