class Api::V1::QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :authenticate_user!
  
  def index
    @questions  = Question.all
    if !@questions.blank?
      render :questions
    else
      render :json => {
        :success => false,
        :message => "There Are No Question Present"
        }, :status => 400
      end
    end

    def view_question
      @question = Question.find_by_id(params[:id])
      if !@question.blank?
        render :question
      else
        render :json => {
          :success => false,
          :message => "Question was not found"
          }, :status => 400
        end
      end

      private 

      def question_params
        params.require(:question).permit(:id, :question, :answer)
      end

    end
