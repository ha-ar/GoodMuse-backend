[:dj,:user].each do |role_name|
	role = Role.find_by(name: role_name)
	if role.blank?
		Role.create! name: role_name
		puts "Role Created"
	end
end

# user = User.create(first_name: "test", last_name: "test", username: "tester", email: "test@goodmuse.com", password: "11111111", password_confirmation: "11111111")

if Question.first.blank?
	Question.create!(question: "Troubleshoot & request removals", answer: "Mail us so we can review the feedback you send and use it to improve the experience for everyone.")
	Question.create!(question: "Filter and refine your results", answer: "You can use Filters and refine your search result.")
	Question.create!(question: "Who is this site for", answer: "This site is for both DJ's and Users.")
	Question.create!(question: "Are the DJ's verified.", answer: "Yes the dj's are verified by long process.")
end
