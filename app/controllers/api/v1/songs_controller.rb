class Api::V1::SongsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :get_song , only: [:update, :show, :destroy]
  
  def index
    @songs  = Song.all
    if !@songs.blank?
      render :json => {
        :success => true,
        :songs => @songs
      }
    else
      render :json => {
        :success => false,
        :errors => "There Are No Song Present"
      }, :status => 400
    end
  end
  
  
  def create 
    if params[:song]
      @song  = Song.new(event_params)

      if @song.save
        render :song
      else
        render :json => {
          :success => false,
          :errors => @song.errors.full_messages.to_sentence
        }, :status => 400
      end
    else
      render :json => {
        :success => false,
        :errors => "Check Params"
      }, :status => 400
    end
  end


  def show
    if !@song.blank?
        render :song
    else
      render :json => {
        :success => false,
        :errors => "Song was not found"
        }, :status => 400
      end
    end


  def update
    if !@song.blank?
      if @song.update(event_params)

        render :song
      else
        render :json => {
          :success => false,
          :errors => @song.errors.full_messages.to_sentence
        }, :status => 400
      end
    else
      render :json => {
        :success => false,
        :errors => "Unable To Find Song"
      }, :status => 400
    end
  end


  
  def destory
    if @song && @song.destroy
      render :json => {
        :message => "Song Deleted.", 
        :success => true
        }
    else
      render :json => {
        :message => "Song Not Found.", 
        :success => false
        }, :status => 400
      end
    end

  
    private 

    def event_params
      params.require(:song).permit(:name, :artist_name, :album, :id)
    end

    def get_song
      @song = Song.find_by_id(params[:id])
    end
  end
