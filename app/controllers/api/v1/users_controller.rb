class Api::V1::UsersController < ApplicationController

  #before_action :authenticate_user! ,  except: [:sign_user , :sign_up , :forgot_password, :social_login, :user_login]
  before_filter :get_user , only: [:update_user, :user_detail, :update_role, :set_fcm_key]
  skip_before_action :verify_authenticity_token
  require 'fcm'

  
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
                :message => @user.errors.full_messages.to_sentence
                }, :status => 400
              end
            else
              render :json => {
                :message => "Role is not correct",
                :success => false
                }, :status => 400
              end
            else
              render :json => {
                :message => "Params Incorrect",
                :success => false
                }, :status => 400
              end

            end

            def user_detail 
              if !@user.blank?
                @likes = 0                    
                if @user.roles.first.present? && @user.roles.first.name == "dj"
                  all_likes = GoingStatus.where(going_status: true).includes(:user)
                  all_likes.each do |like|
                    if like.event.user == @user
                      @likes = @likes + 1
                    end
                  end
                end
                render :show
              else
                render :json => {
                  :success => false,
                  :message => "User was not found"
                  }, :status => 400
                end
              end

              def update_user

                if !@user.blank?
                  if @user.update(user_params)
                   if params[:user][:fcm_key].present?
                    @user.update_attribute(:fcm_key, params[:user][:fcm_key])
                  end
                  if params[:user][:avatar]

                    base64_url = params[:user][:avatar]
                    start = base64_url.index ';base64,'
                    content_type = base64_url[5..start-1]
                    encoded_picture = base64_url[(start+8)..-1]
                    image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
                    image.original_filename = "test.png"
                    @user.update_attributes(:avatar => image)

                  end
                  render :update
                else
                  render :json => {
                    :success => false,
                    :message => @user.errors.full_messages.to_sentence
                    }, :status => 400
                  end
                else
                  render :json => {
                    :success => false,
                    :message => "User was not found"
                    }, :status => 400
                  end
                end



                def forgot_password
                  if params[:user][:email]
                    @user = User.find_by_email(params[:user][:email])
                    if @user
                      raise ActiveRecord::RecordNotFound if not @user.present?
                      password = SecureRandom.hex(4)
                      if @user.update(:password => password)
                        reset_token = @user.send(:set_reset_password_token)
                        UserMailer.forgot_password(@user, reset_token).deliver_now
                        render :json => {
                          :message => "Password Changed Sucessfully",
                          :success => true
                        }
                      else
                        render :json => {
                          :message => "Unable to reset password",
                          :success => false
                          }, :status => 400
                        end
                      else
                        render :json => {
                          :success => false,
                          :message => "Unable To Find User"
                          }, :status => 400
                        end
                      else
                        render :json => {
                          :success => false,
                          :message => "Params Incorrect",
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

                              if params[:user][:fcm_key].present?
                                @user.update_attribute(:fcm_key, params[:user][:fcm_key])
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

                            if params[:user][:fcm_key].present?
                              @user.update_attribute(:fcm_key, params[:user][:fcm_key])
                            end

                            if params[:user][:avatar]
                              # base64_url = params[:user][:avatar]
                              # start = base64_url.index ';base64,'
                              # content_type = base64_url[5..start-1]
                              # encoded_picture = base64_url[(start+8)..-1]
                              # image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
                              # image.original_filename = "test.png"
                              @user.update_attributes(:avatar => params[:user][:avatar])
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

                      @user = User.find_by_email(params[:user][:email].downcase)

                      if @user.present?
                        if @user.valid_password?(params[:user][:password])
                         if params[:user][:fcm_key].present?
                          @user.update_attribute(:fcm_key, params[:user][:fcm_key])
                        end
                        sign_in("user", @user)
                        render :user_login
                      else
                        render :json => {
                          :success => false,
                          :message => "Incorrect Email Or Password."
                          }, :status => 400
                        end
                      elsif params[:user][:email].present? && params[:user][:password].present? 
                        @user =  User.new(user_params)
                        if @user.save

                          if params[:user][:role] and (params[:user][:role] == 'dj' || params[:user][:role] == 'user')
                            @user.add_role params[:user][:role]
                          end
                          if params[:user][:fcm_key].present?
                            @user.update_attribute(:fcm_key, params[:user][:fcm_key])
                          end
                          if params[:user][:avatar]

                            base64_url = params[:user][:avatar]
                            start = base64_url.index ';base64,'
                            content_type = base64_url[5..start-1]
                            encoded_picture = base64_url[(start+8)..-1]
                            image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
                            image.original_filename = "test.png"
                            @user.update_attributes(:avatar => image)

                          end

                          UserMailer.sign_up(@user).deliver_now

                          sign_in("user", @user)
                          @sign_up = true
                          render :user_login
                        else
                          render :json => {
                            :success => false,
                            :message => @user.errors.full_messages.to_sentence
                            }, :status => 400
                          end
                        else
                         render :json => {
                          :success => false,
                          :message => "Incorrect Email Or Password."
                          }, :status => 400
                        end
                      else
                        render :json => {
                          :message => "Check Parameters!",
                          :success => false
                          }, :status => 400
                        end

                      end

                      def update_role

                        if params[:role]
                          if @user.roles.present?
                           @user.roles = []
                         end
                         @user.add_role params[:role]
                         render :json => {
                          :message => "User Role updated sucessfully",
                          :success => true
                          }, :status => 400
                        else
                          render :json => {
                            :message => "Check Parameters!",
                            :success => false
                            }, :status => 400
                          end
                        end

                        def set_fcm_key

                          if !@user.blank?
                           if params[:fcm_key].present?
                            @user.update_attribute(:fcm_key, params[:fcm_key])
                          end

                          render :json => {
                            :success => true,
                            :message => "FCM Key Updated Sucessfully"
                            }, status: 200
                          else
                            render :json => {
                              :success => false,
                              :message => "User was not found"
                              }, :status => 400
                            end
                          end




                          private

                          def user_params
                            params.require(:user).permit(:address, :first_name, :last_name, :username, :email, :password, :provider, :uid, :phone_number)
                          end


                          def get_user 
                            @user = User.find_by_id(params[:id])
                          end


                          def send_notification(registration_id, title, message)
                            fcm = FCM.new("AIzaSyAR5uhnaYL83DrfwUA06JEPexnWWeWsWJk")

                            registration_ids = registration_id

                            options = {}
                            options[:notification] = {}
                            options[:notification][:title] = title
                            options[:notification][:body] = message
                            options[:content_available] = true
                            options[:data] = {
                              title: title,
                              message: message
                            }

                            options[:priority] = "high"

                            @response = fcm.send(registration_ids, options)
                          end

                        end
