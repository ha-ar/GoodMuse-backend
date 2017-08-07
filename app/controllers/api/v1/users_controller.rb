class Api::V1::UsersController < ApplicationController

  before_action :authenticate_user! ,  except: [:sign_user , :sign_up , :reset_password]
  before_filter :get_user , only: [:update, :show]
  
  
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

    def show 
      if !@user.blank?

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

          private

          def user_params
            params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :provider, :uid)
          end


          def get_user 
            @user = User.find_by_id(params[:id])
          end
        end
