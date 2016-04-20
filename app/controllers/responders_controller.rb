class RespondersController < ApplicationController
  before_action :validate_params, only: :create

  def index
    render status: 200,
           json: { responders: Responder.all }
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

  private

  def validate_params
    unpermited_params = %w(id on_duty emergency_code)
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
end
