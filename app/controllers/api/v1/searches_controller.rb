class Api::V1::SearchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :authenticate_user!

  def find_nearby_events

   if params[:longitude].present? && params[:latitude].present?
    @nearby_events = []
    @events = Event.all
    @events.each do |event|
      if params[:range].present? 
        if Geocoder::Calculations.distance_between([params[:latitude].to_f,params[:longitude].to_f], [event.latitude.to_f,event.longitude.to_f], :units => :km).round(2) < params[:range].to_i
          @nearby_events << event
        end
      else
        if Geocoder::Calculations.distance_between([params[:latitude].to_f,params[:longitude].to_f], [event.latitude.to_f,event.longitude.to_f], :units => :km).round(2) < 20
          @nearby_events << event
        end
      end
    end

    
    if params[:user_id].present? 
      user = User.find_by_id(params[:user_id])
      if user.present?
        user_playlist = user.playlists.first
        if user_playlist.present?
          user_song_ids = user_playlist.songs.present? ? user_playlist.songs.pluck(:id) : 0
          user_playlist_event = []
          @nearby_events.each do |event|
            if event.playlists.present? && event.playlists.first.songs.present?
              event_song_ids = event.playlists.first.songs.pluck(:id)
              value = (event_song_ids & user_song_ids).length
              if value > 0
               user_playlist_event << event
             end
           end
         end
         @nearby_events = user_playlist_event
       else
         @nearby_events = []
       end
     else
      @nearby_events = []
    end
  end




  if @nearby_events.present?
    render :events
  else
    render :json => {
      :success => false,
      :message => "No Events Found Nearby."
      }, :status => 400
    end
  end

end


def search_songs
 @discogs = Discogs::Wrapper.new("good_muse", user_token: "RlQwfjOhAfeTdYpudXPTFtasEyrAlSbRiAyHOqBZ")
 search = @discogs.search(params[:song_name],:type => :release)
 @results = search.results

 if @results.present?
  render :songs
else
  render :json => {
    :success => false,
    :message => "No Song Found."
    }, :status => 400
  end
end


def search_djs
  search = params[:search]
  if search
   @users = User.with_role(:dj).where("first_name || ' ' || last_name ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?", search+'%', search+'%', search+'%')
   current_user_playlist = current_user.playlists.first
   if current_user_playlist.present?
     @song_ids = current_user_playlist.songs.present? ? current_user_playlist.songs.pluck(:id) : 0
     @song_count = current_user_playlist.songs.present? ? current_user_playlist.songs.count : 0
   else
     @song_ids = []
     @song_count = []
   end
   render :djs

 else
  render :json => {
    :success => false,
    :message => "No Song Found."
    }, :status => 400
  end
end

end
