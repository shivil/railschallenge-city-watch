class EmergenciesController < ApplicationController
  before_action :validate_create_params, only: :create
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

  private

  def emergency_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def validate_create_params
    unpermited_params = %w(id resolved_at)
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
end
