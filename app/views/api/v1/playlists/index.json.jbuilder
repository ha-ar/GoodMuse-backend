
json.playlists @playlists do |playlist|

  json.id            playlist.id
  json.title         playlist.title

  json.dj  do
    json.id            playlist.user.id
    json.email         playlist.user.email
    json.username      playlist.user.username
  end

  json.songs playlist.songs do |song|
    json.id                 song.id
    json.song_name          song.name
    json.artist_name        song.artist_name
    json.album_name         song.album
    json.tags               song.tags.pluck(:name)
  end


end

json.success true
