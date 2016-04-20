class EmergenciesController < ApplicationController
  before_action :validate_create_params, only: :create
  before_action :validate_update_params, only: :update
  before_action :set_emergency, only: [:show, :update]

  def index
    render status: 200,
           json: {
             emergencies: Emergency.all,
             full_responses: [Responder.count, Emergency.count]
           }
  end

  def create
    emergency = Emergency.new(emergency_params)
    if emergency.save
      render status: 201,
             json: {
               emergency: emergency
             }
    else
      render status: 422,
             json: {
               message: emergency.errors
             }
    end
  end

  def show
    if @emergency
      render status: 200,
             json: { emergency: @emergency }
    else
      render status: 404,
             json: { message: 'emergency not found' }
    end
  end

  def update
    if @emergency.update_attributes(emergency_params)
      render status: 200,
             json: { emergency: @emergency }
    else
      render status: 404,
             json: { message: 'emergency not found' }
    end
  end

  private

  def emergency_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity, :resolved_at)
  end

  def validate_create_params
    unpermited_params = %w(id resolved_at)
    validate_params(unpermited_params)
  end

  def validate_update_params
    unpermited_params = %w(id code)
    validate_params(unpermited_params)
  end

  def validate_params(unpermited_params)
    unpermited_params.each do |unpermited_param|
      if params[:emergency].keys.include? unpermited_param
        return render status: 422,
                      json: {
                        message: "found unpermitted parameter: #{unpermited_param}"
                      }
      end
    end
  end

  def set_emergency
    @emergency =  Emergency.where(code: params[:code]).first
  end
end
