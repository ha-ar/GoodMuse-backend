  json.followers  @followers.each do |follow|
    user = follow.follower
    json.id            user.id
    json.email         user.email
    json.first_name    user.first_name
    json.last_name     user.last_name
    json.username      user.username
    json.phone_number  user.phone_number

    # latest_event = user.events.where("date >= ?", Date.today).first

    # if latest_event.present? && latest_event.playlists.present? && @song_count.present?
    #   playlist_song_ids = latest_event.playlists.first.songs.pluck(:id)
    #   hash_value = (playlist_song_ids & @song_ids).length
    #   percentage_value = ((hash_value.to_f / @song_count.to_f) * 100).round(1)
    # else
    #   playlist_song_ids = nil
    #   percentage_value = nil
    # end

    # json.event  do
    #   json.id                   latest_event.try(:id)
    #   json.name                 latest_event.try(:name)
    #   json.start_time           latest_event.try(:start_time)
    #   json.end_time             latest_event.try(:end_time)
    #   json.avatar               latest_event.try(:image_url)
    #   json.avatar2               latest_event.try(:image_2_url)
    #   json.percentage_match     percentage_value

    # end


  end

  json.success true