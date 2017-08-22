  json.user  do
    json.id            @user.id
    json.email         @user.email
    json.first_name    @user.first_name
    json.last_name     @user.last_name
    json.username      @user.username
    json.role          @user.roles.first.try(:name)
    json.avatar        @user.avatar
    json.created_at    @user.created_at
    json.updated_at    @user.updated_at
    json.provider      @user.provider
    json.uid           @user.uid
  end

  json.success true