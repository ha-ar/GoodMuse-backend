
json.song  do
	
	json.id                 @song.id
	json.song_name          @song.name
	json.artist_name        @song.artist_name
	json.album_name         @song.album
	json.tags               @song.tags.pluck(:name)

end

json.success true

