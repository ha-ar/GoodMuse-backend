  json.djs  @users.each do |user|
    json.id            user.id
    json.email         user.email
    json.first_name    user.first_name
    json.last_name     user.last_name
    json.username      user.username
    json.phone_number  user.phone_number
    json.following     is_following(user.id)

    latest_event = user.events.where("start_time >= ?", Date.today).first
    percentage_value = percentage_value(@song_count,latest_event)

    json.event  do

      json.id                 latest_event.try(:id)
      json.name               latest_event.try(:name)
      json.start_time         latest_event.try(:start_time)
      json.end_time           latest_event.try(:end_time)
      json.venu_name          latest_event.try(:venu_name)
      json.address            latest_event.try(:address)
      json.zip_code           latest_event.try(:zip_code)
      json.price              latest_event.try(:price)
      json.trainers_allowed   latest_event.try(:trainers_allowed)
      json.avatar             latest_event.try(:image_url)
      json.avatar2            latest_event.try(:image_2_url)
      json.latitude           latest_event.try(:latitude)
      json.longitude          latest_event.try(:longitude)
      json.description        latest_event.try(:description)

      json.created_at         latest_event.try(:created_at)
      json.updated_at         latest_event.try(:updated_at)
      json.going              current_user_event_going_status(latest_event.id)
      json.percentage_match   percentage_value

    end


  end

  json.success true