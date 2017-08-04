class Api::V1::PlaylistsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :get_playlist , only: [:update, :view_playlist, :destroy]
  before_action :authenticate_user!


  def index
    @user = User.find_by_id(params[:id])
    if @user.present?
      @playlists  = @user.playlists
    else
      @playlists  = Playlist.all
    end

    if !@playlists.blank?
      render :index

    else
      render :json => {
        :success => false,
        :errors => "There Are No Playlist Present"
        }, :status => 400
      end
    end
    
    
    def create 
      if params[:playlist]
        @playlist  = Playlist.new(playlist_params)
        if @playlist.save
          render :json => {
            :success => true,
            :playlist => @playlist
          }
        else
          render :json => {
            :success => false,
            :errors => @playlist.errors.full_messages.to_sentence
            }, :status => 400
          end
        else
          render :json => {
            :success => false,
            :errors => "Check Params"
            }, :status => 400
          end
        end


        def view_playlist

         if !@playlist.blank?
          render :playlist
        else
          render :json => {
            :success => false,
            :errors => "Playlist was not found"
            }, :status => 400
          end
        end

        def update
          if !@playlist.blank?
            if @playlist.update(playlist_params)
              render :json => {
                :success => true,
                :playlist => @playlist
              }
            else
              render :json => {
                :success => false,
                :errors => @playlist.errors.full_messages.to_sentence
                }, :status => 400
              end
            else
              render :json => {
                :success => false,
                :errors => "Unable To Find Playlist"
                }, :status => 400
              end
            end


            
            def destory
              if @playlist && @playlist.destroy
                render :json => {
                  :message => "Playlist Deleted.", 
                  :success => true
                }
              else
                render :json => {
                  :message => "Playlist Not Found.", 
                  :success => false
                  }, :status => 400
                end
              end

              def add_song_to_playlist

               @discogs = Discogs::Wrapper.new("good_muse", user_token: "RlQwfjOhAfeTdYpudXPTFtasEyrAlSbRiAyHOqBZ")

               @playlist = Playlist.find_by_id(params[:playlist_id])
               search  = @discogs.search(params[:song_name],:type => :release)

               if @playlist.present? && search.results.present?
                first = search.results.first
                title = first.title.split(' - ')
                singer_name = title.first
                song_name = title.last
                album = first.label.first
                tag = first.genre.first
                song = Song.find_by(name: song_name, artist_name: singer_name, album: album)
                unless song.present?
                  song = Song.create(name: song_name, artist_name: singer_name, album: album)
                end
                playlistsong = PlaylistsSongs.find_by(playlist_id: @playlist.id, song_id: song.id)
                unless playlistsong.present?
                  playlistsong = PlaylistsSongs.create(playlist_id: @playlist.id, song_id: song.id)
                end

              end

              if @playlist && song
                render :json => {
                  :playlist => @playlist, 
                  :songs => @playlist.songs, 
                  :success => true
                }
              else
                render :json => {
                  :message => "Error while adding song to playlist.", 
                  :success => false
                  }, :status => 400
                end


              end

              
              private 
              
              def playlist_params
                params.require(:playlist).permit(:title, :user_id)
              end
              
              def get_playlist
                @playlist = Playlist.find_by_id(params[:id])
              end
            end
