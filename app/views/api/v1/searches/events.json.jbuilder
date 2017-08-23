
json.events  @nearby_events do |event|

  json.id                 event.id
  json.name               event.name
  json.date               event.date
  json.venu_name          event.venu_name
  json.address            event.address
  json.zip_code           event.zip_code
  json.price              event.price
  json.trainers_allowed   event.trainers_allowed
  json.avatar             event.avatar.present? "http:" + event.avatar.url : ""
  json.latitude           event.latitude
  json.longitude          event.longitude
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

