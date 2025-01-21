# Класс Train (Поезд):

# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, 
# эти данные указываются при создании экземпляра класса

# Может набирать скорость
# Может возвращать текущую скорость
# Может тормозить (сбрасывать скорость до нуля)
# Может возвращать количество вагонов

# Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто 
# увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может 
# осуществляться только если поезд не движется.

# Может принимать маршрут следования (объект класса Route). 
# При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.

# Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед 
# и назад, но только на 1 станцию за раз.

# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

class Train
  attr_accessor :speed
  attr_reader :wagons
  attr_writer :route

  def initialize(train_number, type)
    @train_number = train_number
    @type = nil
    @route = nil
    @wagons = 0
    @speed = 0
    @route_station_index = 0

    if (type == 'freight' || type == 'passenger')
      @type = type
    else 
      raise "Error: Train can be only Freight or Passenger"
    end
  end

  def set_route(route)
    @route = route
    @route_station_index = 0 if route
  end

  def accelerate(acceleration)
    @speed += acceleration
  end

  def brake
    @speed = 0
  end

  def attach_wagon
    if @speed == 0
      @wagons += 1
    else
      raise "Error: Cannot attach wagon while train is moving"
    end
  end

  def detach_wagon
    if @speed == 0 && @wagons > 0
      @wagons -= 1
    else
      raise "Error: Cannot detach wagon while train is moving or no wagons to detach"
    end
  end

  def current_station
    if @route
      @route.show_station_list[@route_station_index]
    else
      nil
    end
  end

  def next_station
    if @route && @route_station_index < @route.show_station_list.length - 1
      @route.show_station_list[@route_station_index + 1]
    else
      nil
    end
  end

  def previous_station
    if @route && @route_station_index > 0
      @route.show_station_list[@route_station_index - 1]
    else
      nil
    end
  end

  def move_forward
    if @route && @route_station_index < @route.show_station_list.length - 1
      @route_station_index += 1
    else
      raise "Error: No more stations to move forward"
    end
  end

  def move_backward
    if @route && @route_station_index > 0
      @route_station_index -= 1
    else
      raise "Error: No previous station to move backward"
    end
  end
end
