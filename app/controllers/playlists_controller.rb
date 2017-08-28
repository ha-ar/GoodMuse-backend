class PlaylistsController < ApplicationController
  before_filter :authenticate_user!
  before_action :get_playlist ,only: [:edit , :update, :destroy, :show]

  def index
    @playlists = current_user.playlists
  end

  def new
    @playlist = Playlist.new
  end

  def show
  end


  def create

    @playlist = Playlist.new(playlist_params)

    @playlist.user_id = current_user.id
    if @playlist.save


     if params[:songs].present?
      songs = params[:songs]
      @discogs = Discogs::Wrapper.new("good_muse", user_token: "RlQwfjOhAfeTdYpudXPTFtasEyrAlSbRiAyHOqBZ")
      songs.each do |song|
        search  = @discogs.search(song,:type => :release)
        if search.results.present?
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
      end
    end

    flash[:notice] = "Playlist Created Successfully."
    redirect_to playlists_path
  else
    flash[:error] = "Playlist Did not Create. Try again Leter"
    render :new
  end
end

def edit

  if @playlist.blank?
    redirect_to root_path
  end
end

def update

  if @playlist and @playlist.update(playlist_params)
    if params[:songs].present?
      songs = params[:songs]
      @discogs = Discogs::Wrapper.new("good_muse", user_token: "RlQwfjOhAfeTdYpudXPTFtasEyrAlSbRiAyHOqBZ")
      songs.each do |song|
        search  = @discogs.search(song,:type => :release)
        if search.results.present?
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
      end
    end
    flash[:notice] = "Playlist Info Updated."
    redirect_to playlists_path
  else
    flash[:error] = "Playlist Info did not Updated."
    render :edit
  end
end

def destroy
  if @playlist and @playlist.destroy
    flash[:notice] = "Playlist Deleted Successfully"
    redirect_to playlists_path
  else
    flash[:error] = "Unable to delete Playlist."
    redirect_to playlists_path 
  end
end

private

def playlist_params
  params.require(:playlist).permit(:title)
end

def get_playlist
  @playlist = Playlist.find_by_id(params[:id])
end

end
