# frozen_string_literal: true

# The PassengerTrain class represents a train specifically designed for carrying passengers.
# It inherits from the Train class and initializes with a specific number and type.

class PassengerTrain < Train
  def initialize(number)
    super(number, 'passenger')
  end
end
