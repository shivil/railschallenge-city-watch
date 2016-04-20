class Emergency < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true
  validates :fire_severity, presence: true, numericality:  { greater_than_or_equal_to: 0, only_integer: true }
  validates :police_severity, presence: true, numericality:  { greater_than_or_equal_to: 0, only_integer: true }
  validates :medical_severity, presence: true, numericality:  { greater_than_or_equal_to: 0, only_integer: true }

  def responders
    responders = []
    responders << fire_responders
    responders << medical_responders
    responders << police_responders
    responders.flatten
  end

  def police_responders
    responders = []
    police_responder = Responder.police.on_duty.where(capacity: police_severity)
    if police_responder.exists?
      responders << police_responder.first.name
    else
      responder_count = 0
      Responder.police.on_duty.order('capacity desc').each do |responder|
        responders << responder.name if responder_count < police_severity
        responder_count += responder.capacity
      end
    end
    responders
  end

  def fire_responders
    responders = []
    fire_responder = Responder.fire.on_duty.where(capacity: fire_severity)
    if fire_responder.exists?
      responders << fire_responder.first.name
    else
      responder_count = 0
      Responder.fire.on_duty.order('capacity desc').each do |responder|
        responders << responder.name if responder_count < fire_severity
        responder_count += responder.capacity
      end
    end
    responders
  end

  def medical_responders
    responders = []
    medical_responder = Responder.medical.on_duty.where(capacity: medical_severity)
    if medical_responder.exists?
      responders << medical_responder.first.name
    else
      responder_count = 0
      Responder.medical.on_duty.order('capacity desc').each do |responder|
        responders << responder.name if responder_count < medical_severity
        responder_count += responder.capacity
      end
    end
    responders
  end
end
