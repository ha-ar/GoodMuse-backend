
json.events  @events do |event|

  json.id                 event.id
  json.name               event.name
  json.start_time         event.start_time
  json.end_time           event.end_time
  json.venu_name          event.venu_name
  json.address            event.address
  json.zip_code           event.zip_code
  json.price              event.price
  json.trainers_allowed   event.trainers_allowed
  json.avatar             event.image_url
  json.avatar2            event.image_2_url
  json.latitude           event.latitude
  json.longitude          event.longitude
  json.created_at         event.created_at
  json.updated_at         event.updated_at
  json.going              event.is_going(@user.id)

  json.dj  do
    json.id            event.user.id
    json.email         event.user.email
    json.username      event.user.username
  end

  json.genre do
    json.id            event.genre_event.try(:id)
    json.title         event.genre_event.try(:title)
  end

  if event.playlists.present? && @song_count.present?
    playlist_song_ids = event.playlists.first.songs.pluck(:id)
    hash_value = (playlist_song_ids & @song_ids).length
    percentage_value = ((hash_value.to_f / @song_count.to_f) * 100).round(1)
  else
    playlist_song_ids = nil
    percentage_value = nil
  end

  json.playlist do
    json.id                   event.playlists.first.try(:id)
    json.title                event.playlists.first.try(:title)
    json.percentage_match     percentage_value
  end
end

json.success true

