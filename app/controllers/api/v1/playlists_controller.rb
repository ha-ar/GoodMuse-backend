class Api::V1::PlaylistsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :get_playlist , only: [:update, :view_playlist, :destroy, :playlist_matching]
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
                tags = []
                first.genre.each do |tag|
                  unless tags.include? tag
                    tags << tag
                  end
                end

                song = Song.find_by(name: song_name, artist_name: singer_name, album: album)
                unless song.present?
                  song = Song.create(name: song_name, artist_name: singer_name, album: album)
                end

                if tags.present?
                  tags.each do |tag|
                    data_tag = Tag.find_by(name: tag)
                    unless data_tag.present?
                      data_tag = Tag.create(name: tag)
                    end
                    songs_tags = SongsTags.find_by(tag_id: data_tag.id, song_id: song.id)
                    unless songs_tags.present?
                      songs_tags = SongsTags.create(tag_id: data_tag.id, song_id: song.id)
                    end
                  end
                end

                playlistsong = PlaylistsSongs.find_by(playlist_id: @playlist.id, song_id: song.id)
                unless playlistsong.present?
                  playlistsong = PlaylistsSongs.create(playlist_id: @playlist.id, song_id: song.id)
                end

              end

              if @playlist && song
                render :add_to_list
              else
                render :json => {
                  :message => "Error while adding song to playlist.", 
                  :success => false
                  }, :status => 400
                end
              end



              def playlist_matching

                song_ids = @playlist.songs.pluck(:id)
                count = song_ids.count
                playlists = Playlist.all.where.not(user_id: @playlist.user_id )
                playlist_hash = Hash.new{|hsh,key| hsh[key] = [] }
                playlists.each do |playlist|
                  playlist_song_ids = playlist.songs.pluck(:id)
                  hash_value = (playlist_song_ids & song_ids).length
                  playlist_hash[hash_value].push playlist

                end
                playlist = playlist_hash.map{ |value|
                  puts value[0].inspect
                  puts value[1].inspect
                  {
                    :matching_count => value[0],
                    :playlists => value[1].map{ |list|
                      {
                        :id => list.id,
                        :title => list.title
                      }

                     }
                  }
                }
                render :json => {:playlist => playlist}
              end

              
              private 
              
              def playlist_params
                params.require(:playlist).permit(:title, :user_id)
              end
              
              def get_playlist
                @playlist = Playlist.find_by_id(params[:id])
              end
            end
