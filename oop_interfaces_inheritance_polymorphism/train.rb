# Вагоны теперь делятся на грузовые и пассажирские (отдельные классы). К пассажирскому - только пассажирские, к грузовому - грузовые.

class Train
  attr_accessor :speed
  attr_reader :wagons
  attr_writer :route

  def initialize(train_number, type = nil)
    @train_number = train_number
    @type = type
    @route = nil
    @wagons = []
    @speed = 0
    @route_station_index = 0
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

  def attach_wagon(wagon)
    raise "Error: Cannot attach wagon while train is moving" unless @speed.zero?
    raise "Error: Wagon type mismatch" unless wagon.respond_to?(:type) && wagon.type == @type

    @wagons << wagon
  end

  def detach_wagon
    raise "Error: Cannot detach wagon while train is moving or no wagons to detach" unless @speed.zero? || @wagons.positive?

    @wagons.pop
  end

  def current_station
    @route&.show_station_by_number[@route_station_index]
  end

  def next_station
    station_list = @route.get_stations_list
    last_station_index = station_list.positive ? @route.show_stations_list.length : @route.show_stations_list.length - 1

     @route.show_station_by_index[@route_station_index + 1] if @route_station_index < last_station_index
  end

  def previous_station
    @route&.show_stations_list[@route_station_index - 1] if @route_station_index.positive?
  end

  def move_forward
    raise "Error: No route assigned" unless @route

    if @route_station_index < @route.show_stations_list.length - 1
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
