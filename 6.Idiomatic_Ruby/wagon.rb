# frozen_string_literal: true

# Create a new wagon with a random number and specific type that should be identical to train type

# The Wagon class represents a train wagon with a specific type and a random number.
# It includes the Manufacturer module to provide manufacturer-related functionality.
class Wagon
  include Manufacturer
  attr_reader :type, :number

  def initialize(type = nil)
    @type = type
    @number = rand(100..999)
  end
end
