# Разделить поезда на два типа PassengerTrain и CargoTrain, сделать родителя для классов,
# который будет содержать общие методы и свойства

class PassengerTrain < Train
  def initialize(train_number)
    super(train_number, 'passenger')
  end
end
