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



[:airpop ,:afrobeats ,:bigroom ,:brokenbeats ,:chillstep ,:conspiracyrock ,:countrydancemusic ,:dancehall ,:darkbass ,:deephouse ,:disco ,:dnb ,:dub ,:dubstep ,:edm ,:electro ,:futuregarage ,:futurehouse ,:garage ,:glitchpop ,:glitchsoulazz  ,:grime ,:hardcorepunk ,:hardstyle ,:hiphop ,:heavymetal ,:house ,:indie ,:jazz ,:liquiddub ,:loversrock ,:minimaltechno ,:melbournebounce ,:oldschoolhiphop ,:orchestralidm ,:pop ,:progressivehouse ,:progressiveheavyelectrorock ,:psytrance ,:punk ,:punkrock ,:raregroove ,:reggae ,:reggaeton ,:revival ,:rnb ,:rock ,:roots ,:tropicalhouse ,:soca ,:soul ,:soulfulhouse ,:spacetrap ,:oldschoolhiphop ,:techhouse ,:techno ,:trance ,:trap ,"80spop" , "90srnb"].each do |genre_title|
	genre = GenreEvent.find_by(title: genre_title)
	if genre.blank?
		GenreEvent.create! title: genre_title
		puts "Genre  Created"
	end
end

