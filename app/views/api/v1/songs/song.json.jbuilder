
json.song  do

  json.id                 @song.id
  json.song_name               @song.name
  json.artist_name        @song.artist_name
  json.album              @song.album
  
  json.tags song.tags do |tag|
    json.id            tag.id
    json.name          tag.name
  end

end

json.success true

