class Emergency < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true
  validates :fire_severity, presence: true, numericality:  { greater_than_or_equal_to: 0, only_integer: true }
  validates :police_severity, presence: true, numericality:  { greater_than_or_equal_to: 0, only_integer: true }
  validates :medical_severity, presence: true, numericality:  { greater_than_or_equal_to: 0, only_integer: true }
end
