  json.user  do
    json.id            @user.id
    json.email         @user.email
    json.username      @user.username
    json.phone_number  @user.phone_number
    if  @user.roles.present?
      json.role          @user.roles.first.try(:name)
    end
    json.avatar        @user.avatar.present? ? "http:" + @user.avatar.url : ""
    json.provider      @user.provider
    json.uid           @user.uid
    json.created_at    @user.created_at
    json.updated_at    @user.updated_at
  end

  if @sign_up.present?
    json.message "Thank You For Joining Good Muse"
  else
    json.message "You Have Successfully Logged Into Good Muse"  
  end

  json.success true