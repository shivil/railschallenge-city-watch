class RespondersController < ApplicationController
  before_action :validate_create_params, only: :create
  before_action :validate_update_params, only: :update
  before_action :set_responder, only: [:show, :update]

  def index
    render status: 200,
           json: { responders: Responder.all }
  end

  def show
    if @responder
      render status: 200,
             json: { responder: @responder }
    else
      render status: 404,
             json: { message: 'responder not found' }
    end
  end

  def create
    responder = Responder.new(responder_params)
    if responder.save
      render status: 201,
             json: {
               responder: responder
             }
    else
      render status: 422,
             json: {
               message: responder.errors
             }
    end
  end

  def update
    if @responder.update_attributes(responder_params)
      render status: 200,
             json: { responder: @responder }
    else
      render status: 404,
             json: { message: 'responder not found' }
    end
  end

  private

  def validate_create_params
    unpermited_params = %w(id on_duty emergency_code)
    validate_params(unpermited_params)
  end

  def validate_update_params
    unpermited_params = %w(id emergency_code type name capacity)
    validate_params(unpermited_params)
  end

  def validate_params(unpermited_params)
    unpermited_params.each do |unpermited_param|
      if params[:responder].keys.include? unpermited_param
        return render status: 422,
                      json: {
                        message: "found unpermitted parameter: #{unpermited_param}"
                      }
      end
    end
  end

  def responder_params
    params.require(:responder).permit(:name, :type, :capacity, :on_duty)
  end

  def set_responder
    @responder =  Responder.where(name: params[:name]).first
  end
end
