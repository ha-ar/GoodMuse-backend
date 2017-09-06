class Api::V1::GoingStatusesController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :authenticate_user!
  before_filter :get_going_status , only: [:update, :show, :destroy]
  
  def index
    @going_statuses = GoingStatus.all
    if !@going_statuses.blank?
      render :json => {
        :success => true,
        :going_statuses => @going_statuses
      }
    else
      render :json => {
        :success => false,
        :message => "There Are No Status Present"
      }, :status => 400
    end
  end
  
  
  def create 
    if params[:going_status]
      @going_status  = GoingStatus.new(going_status_params)

      if @going_status.save
        render :going_status
      else
        aaaa
        render :json => {
          :success => false,
          :message => @going_status.errors.full_messages.to_sentence
        }, :status => 400
      end
    else
      ccc
      render :json => {
        :success => false,
        :message => "Check Params"
      }, :status => 400
    end
  end


  def show
    if !@going_status.blank?
        render :going_status
    else
      render :json => {
        :success => false,
        :message => "Status was not found"
        }, :status => 400
      end
    end


  def update
    if !@going_status.blank?
      if @going_status.update(going_status_params)

        render :going_status
      else
        render :json => {
          :success => false,
          :message => @going_status.errors.full_messages.to_sentence
        }, :status => 400
      end
    else
      render :json => {
        :success => false,
        :message => "Unable To Find Status"
      }, :status => 400
    end
  end


  
  def destory
    if @going_status && @going_status.destroy
      render :json => {
        :message => "Status Deleted.", 
        :success => true
        }
    else
      render :json => {
        :message => "Status Not Found.", 
        :success => false
        }, :status => 400
      end
    end

  
    private 

    def going_status_params
      params.require(:going_status).permit(:going_status, :event_id, :user_id, :id)
    end

    def get_going_status
      @going_status = GoingStatus.find_by_id(params[:id])
    end
  end
