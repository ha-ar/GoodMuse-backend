json.songs @results do |song|

  json.artist_name   song.title.split(' - ').first
  json.song_name     	 song.title.split(' - ').last
  json.album_name    song.label.first
  json.tags          song.genre

end

json.success true