class Api::V1::GenresController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :authenticate_user!
  
  def index
    @genres = GenreEvent.all
    if !@genres.blank?
      render :genres

    else
      render :json => {
        :success => false,
        :message => "There Are No Genres Present"
        }, :status => 400
      end
    end


  end
