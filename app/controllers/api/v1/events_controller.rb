class Api::V1::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :authenticate_user!
  before_filter :get_event , only: [:update_event, :view_event, :delete_event]
  
  def index
    @events  = Event.all
    if !@events.blank?
      render :json => {
        :success => true,
        :events => @events
      }
    else
      render :json => {
        :success => false,
        :message => "There Are No Event Present"
        }, :status => 400
      end
    end


    def create 


      if params[:event]
        @event  = Event.new(event_params)

        if @event.save

          if params[:event][:avatar]
            base64_url = params[:event][:avatar]

            start = base64_url.index ';base64,'
            content_type = base64_url[5..start-1]
            encoded_picture = base64_url[(start+8)..-1]

            image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
            image.original_filename = "test.png"
            @event.update_attributes(:avatar => image)
          end

          if params[:event][:avatar2]
            base64_url = params[:event][:avatar2]

            start = base64_url.index ';base64,'
            content_type = base64_url[5..start-1]
            encoded_picture = base64_url[(start+8)..-1]

            image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
            image.original_filename = "test.png"
            @event.update_attributes(:avatar2 => image)
          end

          if params[:event][:playlist_id]
            playlist = Playlist.find_by(id: params[:event][:playlist_id])
            if playlist.present?
              events_playlists = EventsPlaylists.find_by(event_id: @event.id, playlist_id: playlist.id)
              unless events_playlists.present?
                events_playlists = EventsPlaylists.create(event_id: @event.id, playlist_id: playlist.id)
              end
            end
          end

          render :event
        else
          render :json => {
            :success => false,
            :message => @event.errors.full_messages.to_sentence
            }, :status => 400
          end
        else
          render :json => {
            :success => false,
            :message => "Check Params"
            }, :status => 400
          end
        end


        def view_event
          if !@event.blank?
            if @event.avatar.present?
              @image = URI.parse(URI.encode(@event.avatar.url.to_s))
              @image = "http://" + @image.host + @image.path
            else
              @image = nil
            end
            render :event
          else
            render :json => {
              :success => false,
              :message => "Event was not found"
              }, :status => 400
            end
          end



          def update_event
            if !@event.blank?
              if @event.update(event_params)

               if params[:event][:avatar]
                base64_url = params[:event][:avatar]
                start = base64_url.index ';base64,'
                content_type = base64_url[5..start-1]
                encoded_picture = base64_url[(start+8)..-1]

                image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
                image.original_filename = "test.png"
                @event.update_attributes(:avatar => image)
              end

              if params[:event][:avatar2]
                base64_url = params[:event][:avatar2]

                start = base64_url.index ';base64,'
                content_type = base64_url[5..start-1]
                encoded_picture = base64_url[(start+8)..-1]

                image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
                image.original_filename = "test.png"
                @event.update_attributes(:avatar2 => image)
              end

              if params[:event][:playlist_id]
                playlist = Playlist.find_by(id: params[:event][:playlist_id])
                if playlist.present?
                  old_playlist = EventsPlaylists.find_by(event_id: @event.id)
                  old_playlist.destroy
                  events_playlists = EventsPlaylists.find_by(event_id: @event.id, playlist_id: playlist.id)
                  unless events_playlists.present?
                    events_playlists = EventsPlaylists.create(event_id: @event.id, playlist_id: playlist.id)
                  end
                end
              end

              render :event
            else
              render :json => {
                :success => false,
                :message => @event.errors.full_messages.to_sentence
                }, :status => 400
              end
            else
              render :json => {
                :success => false,
                :message => "Unable To Find Event"
                }, :status => 400
              end
            end



            def delete_event
              if @event && @event.destroy
                render :json => {
                  :message => "Event Deleted.", 
                  :success => true
                }
              else
                render :json => {
                  :message => "Event Not Found.", 
                  :success => false
                  }, :status => 400
                end
              end


              def upcoming_events
                offset_value = params[:offset].to_i * 10
                @events  = Event.where("start_time >= ?", Date.today).limit(10).offset(offset_value).order("start_time ASC")

                if @events.present?
                  render :events
                else
                  render :json => {
                    :message => "Events Not Found.", 
                    :success => false
                    }, :status => 400
                  end
                end

                def my_events
                  if params[:id].present?
                    @user = User.find_by_id(params[:id])
                    if @user.present?
                      @events  = @user.events
                      if @events.present?
                        render :events
                      else
                        render :json => {
                          :message => "Events Not Found.", 
                          :success => false
                          }, :status => 400
                        end
                      else
                        render :json => {
                          :message => "User Not Found.", 
                          :success => false
                          }, :status => 400
                        end
                      else
                        render :json => {
                          :message => "Check Parameters!", 
                          :success => false
                          }, :status => 400
                        end
                      end


                      def going_to_events
                       if params[:id].present?
                        @user = User.find_by_id(params[:id])
                        if @user.present?
                          @events = []
                          statuses  = @user.going_statuses
                          statuses.each do |status|
                            if status.event.start_time.present? && status.going_status
                              @events << status.event
                            end
                          end
                          if @events.present?
                            @events = @events.sort_by(&:start_time)
                            render :going_to_events
                          else
                            render :json => {
                              :message => "No Events Found.", 
                              :success => false
                              }, :status => 400
                            end
                          else
                            render :json => {
                              :message => "User Not Found.", 
                              :success => false
                              }, :status => 400
                            end
                          else
                            render :json => {
                              :message => "Check Parameters!", 
                              :success => false
                              }, :status => 400
                            end
                          end


                          def event_likes
                            if params[:event_id].present?
                              @likes = GoingStatus.where(event_id: params[:event_id], going_status: true).includes(:user)                    

                              if @likes.present?
                                render :event_likes
                              else
                                render :json => {
                                  :message => "No User Going To This Event.", 
                                  :success => false
                                  }, :status => 400
                                end


                              else
                                render :json => {
                                  :message => "Check Parameters!", 
                                  :success => false
                                  }, :status => 400
                                end

                              end


                              private 

                              def event_params
                                params.require(:event).permit(:genre_event_id, :user_id, :name, :start_time, :venu_name, :address, :zip_code, :end_time, :price, :trainers_allowed, :upload_flyer, :playlist_tag, :longitude, :latitude)
                              end

                              def get_event
                                @event = Event.find_by_id(params[:id])
                              end
                            end
