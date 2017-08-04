class HomeController < ApplicationController

	def index
		@discogs = Discogs::Wrapper.new("good_muse", user_token: "RlQwfjOhAfeTdYpudXPTFtasEyrAlSbRiAyHOqBZ")

		@search  = @discogs.search("Hello",:type => :release)
		puts "sssssssssssssss"
		puts @search.inspect
		puts "sssssssssssssss"

	end
end
