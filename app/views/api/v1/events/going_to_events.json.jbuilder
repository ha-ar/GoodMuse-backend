
json.events  @events.each do |event|

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
  json.avatar2             event.image_2_url
  json.latitude           event.latitude
  json.longitude          event.longitude
  json.is_going           going_status(event.id, @user.id)
  json.created_at         event.created_at
  json.updated_at         event.updated_at

  json.dj  do
    json.id            event.user.id
    json.email         event.user.email
    json.username      event.user.username
  end

  json.playlist do
    json.id            event.playlists.first.try(:id)
    json.title         event.playlists.first.try(:title)
  end

end

json.success true

