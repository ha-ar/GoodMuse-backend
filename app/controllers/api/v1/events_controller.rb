class Api::V1::EventsController < ApplicationController

  before_filter :get_event , only: [:update, :show, :destroy]
  
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
        :errors => "There Are No Event Present"
      }, :status => 400
    end
  end
  
  
  def create 
    if params[:event]
      @event  = Event.new(event_params)
      if @event.save
        render :json => {
          :success => true,
          :event => @event
        }
      else
        render :json => {
          :success => false,
          :errors => @event.errors.full_messages.to_sentence
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
    if !@event.blank?
      render :json => {
        :success => true,
        :event => @event
      }
    else
      render :json => {
        :success => false,
        :errors => "Event was not found"
        }, :status => 400
      end
    end


  def update
    if !@event.blank?
      if @event.update(event_params)
        render :json => {
          :success => true,
          :event => @event
        }
      else
        render :json => {
          :success => false,
          :errors => @event.errors.full_messages.to_sentence
        }, :status => 400
      end
    else
      render :json => {
        :success => false,
        :errors => "Unable To Find Event"
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

  
  private 
  
  def event_params
    params.require(:event).permit(:name, :date, :venu_name, :address, :zip_code, :end_time, :price, :trainers_allowed, :upload_flyer, :playlist_tag)
  end
  
  def get_event
    @event = Event.find_by_id(params[:id])
  end
end
