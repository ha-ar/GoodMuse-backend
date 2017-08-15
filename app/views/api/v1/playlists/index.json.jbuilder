
json.playlists @playlists do |playlist|

  json.id            playlist.id
  json.title         playlist.title

  json.dj  do
    json.id            playlist.user.id
    json.email         playlist.user.email
  end

  json.songs playlist.songs do |song|
    json.id            song.id
    json.name          song.name
    json.artist_name   song.artist_name
    json.album         song.album

  end


end

json.success true