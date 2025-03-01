class Wagon
  include Manufacturer
  attr_reader :type, :number

  def initialize(type = nil)
    @type = type
    @number = rand(100..999)
  end
end
