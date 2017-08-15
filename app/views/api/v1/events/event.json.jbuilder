
json.event  do

  json.id                 @event.id
  json.name               @event.name
  json.date               @event.date.strftime("%d-%m-%Y")
  json.venu_name          @event.venu_name
  json.address            @event.address
  json.zip_code           @event.zip_code
  json.end_time           @event.end_time.strftime("%H:%M:%S")
  json.price              @event.price
  json.trainers_allowed   @event.trainers_allowed
  json.avatar             @event.avatar
  json.created_at         @event.created_at
  json.updated_at         @event.updated_at

  json.dj  do
    json.id            @event.user.id
    json.email         @event.user.email
  end

  json.playlist do
    json.id            @event.playlists.first.try(:id)
    json.title         @event.playlists.first.try(:title)
  end
end

json.success true

