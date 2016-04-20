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
end
