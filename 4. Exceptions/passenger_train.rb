# Разделить поезда на два типа PassengerTrain и CargoTrain, сделать родителя для классов,
# который будет содержать общие методы и свойства

class PassengerTrain < Train
  def initialize(number)
    super(number, 'passenger')
  end
end
