# Класс Station (Станция):
# Имеет название, которое указывается при ее создании
# Может принимать поезда (по одному за раз)
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

class Station
  attr_reader :trains

  def initialize(station_name)
    @station_name = station_name
    @trains = []
  end

  def receive_train(train)
    @trains.push(train)
  end

  def dispatch_train
    @trains.pop
  end

  def get_train_list_by_type(type)
    case type
    when 'passenger'
      @trains.select { |train| train.type == 'passenger' }
    when 'freight'
      @trains.select { |train| train.type == 'freight' }
    else
      raise ArgumentError, "Invalid train type: #{type}"
    end
  end
end
