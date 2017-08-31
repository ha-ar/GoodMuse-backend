class Api::V1::UsersController < ApplicationController

  #before_action :authenticate_user! ,  except: [:sign_user , :sign_up , :forgot_password, :social_login, :user_login]
  before_filter :get_user , only: [:update, :user_detail, :update_role, :set_fcm_key]
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
                render :show
              else
                render :json => {
                  :success => false,
                  :message => "User was not found"
                  }, :status => 400
                end
              end

              def update

                if !@user.blank?
                  if @user.update(user_params)
                   if params[:user][:fcm_key].present?
                    @user.update_attribute(:fcm_key, params[:user][:fcm_key])
                  end

                  render :json => {
                    :success => true,
                    :message => "User Updated Sucessfully"
                    }, status: 200
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
                                base64_url = "data:image/png;base64,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"
                                  #base64_url = params[:user][:avatar]
                                  start = base64_url.index ';base64,'
                                  content_type = base64_url[5..start-1]
                                  encoded_picture = base64_url[(start+8)..-1]
                                  image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
                                  image.original_filename = "test.png"
                                  @user.update_attributes(:avatar => image)
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

                                base64_url = "data:image/png;base64,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"
                                  #base64_url = params[:user][:avatar]
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
