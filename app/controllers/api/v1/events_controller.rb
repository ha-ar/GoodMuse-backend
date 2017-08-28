class Api::V1::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :authenticate_user!
  before_filter :get_event , only: [:update_event, :view_event, :destroy]
  
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

         if params[:event][:avatar].present?
          image = Base64.decode64(params[:event][:avatar])
          @user.update_attributes(:avatar => image)
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
          render :event
        else
          render :json => {
            :success => false,
            :message => "Event was not found"
            }, :status => 400
          end
        end


        def update
          if !@event.blank?
            if @event.update(event_params)

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

            def update_event
              if !@event.blank?
                if @event.update(event_params)

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



                def destory
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
                    @events  = Event.where("date >= ?", Date.today)
                    if @events.present?
                      render :events
                    else
                      render :json => {
                        :message => "Events Not Found.", 
                        :success => false
                        }, :status => 400
                      end
                    end


                    private 

                    def event_params
                      params.require(:event).permit(:user_id, :name, :start_time, :venu_name, :address, :zip_code, :end_time, :price, :trainers_allowed, :upload_flyer, :playlist_tag, :longitude, :latitude)
                    end

                    def get_event
                      @event = Event.find_by_id(params[:id])
                    end
                  end
