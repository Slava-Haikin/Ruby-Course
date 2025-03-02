class Route
  include InstanceCounter
  attr_reader :name, :stations

  def initialize(starting_station, final_station)
    @name = "#{starting_station&.name} - #{final_station&.name}"
    @starting_station = starting_station
    @final_station = final_station
    @stations = []

    validate!

    register_instance if respond_to?(:register_instance)
  end

  def add_station(station)
    @stations << station
  end

  def remove_station(station)
    @stations.delete(station)
  end

  def get_stations_list
    [@starting_station, *@stations, @final_station]
  end

  def show_station_by_number(number)
    raise ArgumentError unless number >= 0

    puts get_stations_list[number]
  end

  protected
  def valid?
    !@starting_station.empty? && !@final_station.empty?
  end

  def validate!
    raise "Invalid starting or final station" unless valid?
  end
end
