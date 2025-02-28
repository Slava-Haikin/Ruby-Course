=begin
Класс Station (Станция):
  - Имеет название, которое указывается при ее создании
  - Может принимать поезда (по одному за раз)
  - Может возвращать список всех поездов на станции, находящиеся в текущий момент
  - Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  - Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
=end

class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def receive_train(train)
    @trains.push(train)
  end

  def dispatch_train(train)
    @trains.delete(train)
  end

  def get_train_list_by_type(type)
      raise ArgumentError, "Invalid train type: #{type}" unless ['cargo', 'passenger'].include?(type)
      @trains.select { |train| train.type == type }
  end
end
