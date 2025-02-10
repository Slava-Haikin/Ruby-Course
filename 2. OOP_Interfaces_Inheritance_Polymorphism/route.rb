=begin
Класс Route (Маршрут):
- Имеет начальную и конечную станцию, а также список промежуточных станций.
- Начальная и конечная станции указываются при создании маршрута, а промежуточные могут добавляться между ними.
- Может добавлять промежуточную станцию в список
- Может удалять промежуточную станцию из списка
- Может выводить список всех станций по-порядку от начальной до конечной
=end

class Route
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
