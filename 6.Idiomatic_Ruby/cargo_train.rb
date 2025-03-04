# The CargoTrain class represents a train specifically designed for carrying cargo.
# It inherits from the Train class and initializes with a specific number and type.

# frozen_string_literal: true

class CargoTrain < Train
  def initialize(number)
    super(number, 'cargo')
  end
end
