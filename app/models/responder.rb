class Responder < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  validates :capacity, :presence => true, :inclusion => 1..5
  validates :name, :presence => true, :uniqueness => true
end