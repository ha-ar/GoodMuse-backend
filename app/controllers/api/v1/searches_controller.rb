class Api::V1::SearchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :authenticate_user!

  def find_nearby_events

   if params[:longitude].present? && params[:latitude].present?
    @nearby_events = []
    @events = Event.all
    @events.each do |event|

      if Geocoder::Calculations.distance_between([params[:latitude].to_i,params[:longitude].to_i], [event.latitude.to_i,event.longitude.to_i], :units => :km).round(2) < 10
        @nearby_events << event
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
