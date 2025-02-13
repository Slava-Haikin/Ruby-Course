# Подключить модуль счетчика в класс маршрута.

class Route
  include InstanceCounter
  attr_reader :name, :stations

  def initialize(starting_station, final_station)
    @name = "#{starting_station&.name} - #{final_station&.name}"
    @starting_station = starting_station
    @final_station = final_station
    @stations = []
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
end
