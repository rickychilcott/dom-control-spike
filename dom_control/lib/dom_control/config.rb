class DomControl::Config
  attr_accessor :check, :check_multi
  attr_accessor :serialize_resource_as

  def initialize
    self.check_multi           = nil
    self.check                 = ->(key, subject) { false }
    self.serialize_resource_as = :dom_id
  end
end