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
      json.id                   latest_event.try(:id)
      json.name                 latest_event.try(:name)
      json.start_time           latest_event.try(:start_time)
      json.end_time             latest_event.try(:end_time)
      json.avatar               latest_event.try(:image_url)
      json.avatar2              latest_event.try(:image_2_url)
      json.percentage_match     percentage_value

    end


  end

  json.success true