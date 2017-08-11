class Api::V1::UsersController < ApplicationController

  before_action :authenticate_user! ,  except: [:sign_user , :sign_up , :reset_password, :social_login, :user_login]
  before_filter :get_user , only: [:update, :user_detail, :update_role]
  skip_before_action :verify_authenticity_token

  
  def sign_user
    if params[:user]

      @user = User.find_by_email(params[:user][:email])

      if @user
        if @user.valid_password?(params[:user][:password])
          sign_in("user", @user)
          render :sign_user
          else
            render :json => {
              :success => false,
              :message => "Incorrect Password"
            }, :status => 400
          end
        else
          render :json => {
            :success => false,
            message: "User not found"
          }, :status => 400
        end
      else

      end
    end

    def sign_up

      if params[:user] 
        if params[:user][:role] and (params[:user][:role] == 'dj' || params[:user][:role] == 'user')
          @user =  User.new(user_params)
          if @user.save
            @user.add_role params[:user][:role]
            sign_in("user", @user)

          else
            render :json => {
              :success => false,
              :errors => @user.errors.full_messages.to_sentence
            }, :status => 400
          end
        else
          render :json => {
            :error => "Role is not correct",
            :success => false
          }, :status => 400
        end
      else
        render :json => {
          :error => "Params Incorrect",
          :success => false
        }, :status => 400
      end

    end

    def user_detail 
      if !@user.blank?
          render :show
      else
        render :json => {
          :success => false,
          :errors => "User was not found"
        }, :status => 400
      end
    end

    def update

      if !@user.blank?
        if @user.update(user_params)
          render :json => {
            :success => true,
            :message => "User Updated Sucessfully"
            }, status: 200
        else
          render :json => {
            :success => false,
            :errors => @user.errors.full_messages.to_sentence
          }, :status => 400
        end
      else
        render :json => {
          :success => false,
          :errors => "User was not found"
        }, :status => 400
      end
    end



    def reset_password
      if params[:user][:email]
        @user = User.find_by_email(params[:user][:email])
        if @user
          raise ActiveRecord::RecordNotFound if not @user.present?
          password = SecureRandom.hex(4)
          if @user.update(:password => password)
            UserMailer.reset_password(@user, password).deliver_now

          else
            render :json => {
              :errors => "Unable to reset password",
              :success => false
              }, :status => 400
            end
          else
            render :json => {
              :success => false,
              :errors => "User was not found"
              }, :status => 400
            end
          else
            render :json => {
              :success => false,
              :error => "Params Incorrect",
              }, :status => 400
            end
          end


          def social_login

            
            user_email = params[:user][:email]
            user_name = params[:user][:username]
            uid = params[:user][:social_id]
            provider = params[:user][:social_type]
            role = params[:user][:role]
            phone_number = params[:user][:phone_number]
            password = Devise.friendly_token.first(8)



            if uid.present?
              if (uid != "null" )

                if user_email.present?
                  @user = User.find_by(email: user_email)
                end
                unless @user.present?
                  @user = User.find_by(uid: uid, provider: provider)
                end

                if @user.present?
                  
                  user_id = @user.id.to_s
                  @user.update_attributes(:username => user_name, :uid => uid)

                  if provider.present?
                    @user.update_attributes(:provider => provider)
                  end
                  
                  if phone_number.present?
                    @user.update_attributes(:phone_number => phone_number)
                  end
                  
                  if user_email.present? && !@user.email.present?
                    @user.update_attributes(:email => user_email)
                  end

                  sign_in("user", @user)
                  render :social_login

                else

                  if user_email.present?
                    @user = User.new(:email => user_email, :uid => uid, :password => password, provider: provider)
                  else
                   @user = User.new(:uid => uid, provider: provider, :password => password)
                 end

                  @user.save!

                  if user_name.present?
                    @user.update_attributes(:username => user_name)
                  end
                  if phone_number.present?
                    @user.update_attributes(:phone_number => phone_number)
                  end
                  
                  if provider.present?
                    @user.update_attributes(:provider => provider)
                  end
                  if role.present?
                    @user.add_role role
                  end
                  
                  @sign_up = true
                  sign_in("user", @user)
                  render :social_login

                end
              else
                render :json => {:success => "false", :message => "User provider identity not present"}
              end
            else
              render :json => {:success => "false", :message => "User provider identity not present"}
            end
          end


          def user_login

           if params[:user]

            @user = User.find_by_email(params[:user][:email])

            if @user.present?
              if @user.valid_password?(params[:user][:password])
                sign_in("user", @user)
                render :user_login
              else
                render :json => {
                  :success => false,
                  :message => "Incorrect Password"
                  }, :status => 400
                end
              else
                @user =  User.new(user_params)
                if @user.save

                  if params[:user][:role] and (params[:user][:role] == 'dj' || params[:user][:role] == 'user')
                    @user.add_role params[:user][:role]
                  end

                  sign_in("user", @user)
                  @sign_up = true
                  render :user_login
                else
                  render :json => {
                    :success => false,
                    :errors => @user.errors.full_messages.to_sentence
                    }, :status => 400
                  end
                end
              else
                render :json => {
                  :error => "Check Parameters!",
                  :success => false
                  }, :status => 400
                end

              end

              def update_role

                if params[:role]
                  @user.add_role params[:role]
                  render :json => {
                    :error => "User Role updated sucessfully",
                    :success => true
                    }, :status => 400
                  else
                    render :json => {
                      :error => "Check Parameters!",
                      :success => false
                      }, :status => 400
                    end
                  end




          private

          def user_params
            params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :provider, :uid, :phone_number)
          end


          def get_user 
            @user = User.find_by_id(params[:id])
          end
        end
