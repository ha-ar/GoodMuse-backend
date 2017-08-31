  json.user  do
    json.id            @user.id
    json.email         @user.email
    json.username      @user.username
    json.role          @user.roles.first.try(:name)
    json.avatar        @user.avatar.present? ? "http:" + @user.avatar.url : ""
    json.fcm_key       @user.fcm_key
    json.created_at    @user.created_at
    json.updated_at    @user.updated_at
  end

  if @sign_up.present?
    json.message "Thank You For Joining Good Muse"
  else
    json.message "You Have Successfully Logged Into Good Muse"  
  end


  json.success true