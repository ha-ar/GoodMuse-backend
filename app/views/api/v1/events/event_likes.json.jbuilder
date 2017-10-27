
json.event_likes  @likes.each do |like|

    json.id            like.user.try(:id)
    json.email         like.user.try(:email)
    json.first_name    like.user.try(:first_name)
    json.last_name     like.user.try(:last_name)
    json.username      like.user.try(:username)
    json.role          like.user.roles.first.try(:name)
    json.phone_number  like.user.try(:phone_number)
    json.avatar        like.user.try(:image_url)
    json.fcm_key       like.user.try(:fcm_key)
    json.created_at    like.user.created_at
    json.updated_at    like.user.updated_at
    json.provider      like.user.try(:provider)
    json.uid           like.user.try(:uid)


end

json.success true

