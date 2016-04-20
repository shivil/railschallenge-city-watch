class Responder < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  validates :capacity, presence: true, inclusion: 1..5
  validates :name, presence: true, uniqueness: true
  validates :type, presence: true

  def as_json(_options = {})
    super(only:
            [:emergency_code,
             :type,
             :name,
             :capacity,
             :on_duty])
  end

  def self.show_capacity
    result = {}
    Responder.all.map do |responder|
      result[responder.type] ||= []
      result[responder.type] << responder.capacity
    end
    result
  end

  def self.police
    where(type: 'Police')
  end

  def self.fire
    where(type: 'Fire')
  end

  def self.medical
    where(type: 'Medical')
  end

  def self.on_duty
    where(on_duty: true)
  end
end
