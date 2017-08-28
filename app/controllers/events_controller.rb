class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_action :get_event ,only: [:edit , :update, :destroy, :show]

  def index
    @events = Event.all
  end

  def my_events
    @events = current_user.events
  end

  def new
    @event = Event.new
    @playlists = current_user.playlists
    @check = nil

  end

  def show
    @playlists = @event.playlists.includes(:songs)
  end


  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      EventsPlaylists.create(event_id: @event.id, playlist_id: params[:event][:playlist_ids])
      flash[:notice] = "Event Created Successfully."
      redirect_to my_events_events_path
    else
      flash[:notice] = @event.errors.full_messages
      render :new
    end
  end

  def edit

    if @event.blank?
      redirect_to root_path
    end
    @playlists = current_user.playlists
    @check = @event.playlists.first.id
  end

  def update
    if @event and @event.update(event_params)

      if params[:event][:playlist_ids]
        playlist = Playlist.find_by(id: params[:event][:playlist_ids])

        if playlist.present?

          old_playlist = @event.playlists.first
          
          if old_playlist != playlist
            old_event_playlists = EventsPlaylists.find_by(event_id: @event.id, playlist_id: old_playlist.id)
            old_event_playlists.destroy
            events_playlists = EventsPlaylists.create(event_id: @event.id, playlist_id: playlist.id)
          end
        end
      end


      flash[:notice] = "Event Info Updated."
      redirect_to my_events_events_path
    else
      flash[:error] = "Event Info did not Updated."
      render :edit
    end
  end

  def destroy
    if @event and @event.destroy
      flash[:notice] = "Event Deleted Successfully"
      redirect_to my_events_events_path
    else
      flash[:error] = "Unable to delete Event."
      redirect_to my_events_events_path 
    end
  end

  private

  def event_params
    params.require(:event).permit(:avatar, :user_id, :name, :date, :venu_name, :address, :zip_code, :end_time, :price, :trainers_allowed, :upload_flyer, :playlist_tag, :longitude, :latitude, :playlist_ids => [])
  end

  def get_event
    @event = Event.find_by_id(params[:id])
  end

end
