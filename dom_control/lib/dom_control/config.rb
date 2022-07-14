class DomControl::Config
  attr_accessor :check

  def initialize
    check = -> { false }
  end
end