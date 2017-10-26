class Api::V1::FollowingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  


  def follow
    if params[:dj_id] && params[:follower_id]
      following  = Following.find_by(follower_id: params[:follower_id], user_id: params[:dj_id])
      if following.present?
        render :json => {
          :success => false,
          :message => "User Already Following this Dj"
          }, :status => 400
        else
         @follower  = Following.create(follower_id: params[:follower_id], user_id: params[:dj_id])
         if @follower
           render :json => {
            :success => true,
            :message => "User is now following DJ"
          }
        else
          render :json => {
            :success => false,
            :message => @follower.errors.full_messages.to_sentence
            }, :status => 400
          end
        end

      else
        render :json => {
          :success => false,
          :message => "Check Params"
          }, :status => 400
        end
      end


      def unfollow
        if params[:dj_id] && params[:follower_id]
          following  = Following.find_by(follower_id: params[:follower_id], user_id: params[:dj_id])
          
          if following.present? && following.destroy
            render :json => {
              :success => true,
              :message => "User has Unfollow this Dj"
              }, :status => 400
            else
              render :json => {
                :success => false,
                :message => "User not following this Dj"
                }, :status => 400
              end

            else
              render :json => {
                :success => false,
                :message => "Check Params"
                }, :status => 400
              end
              
            end



            def all_followers
              @user = User.find_by_id(params[:user_id])
              @followers = @user.followers

              if !@followers.blank?
                render :followers
              else
                render :json => {
                  :success => false,
                  :message => "There Are No Followers Present"
                  }, :status => 400
                end
              end


              def all_following
                @user = User.find_by_id(params[:user_id])
                @following = @user.following

                if !@following.blank?
                  render :following
                else
                  render :json => {
                    :success => false,
                    :message => "There Are No Following Present"
                    }, :status => 400
                  end
                end



              end
