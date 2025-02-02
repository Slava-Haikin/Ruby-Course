=begin
Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
 - Создавать станции
 - Создавать поезда
 - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
 - Назначать маршрут поезду
 - Добавлять вагоны к поезду
 - Отцеплять вагоны от поезда
 - Перемещать поезд по маршруту вперед и назад
 - Просматривать список станций и список поездов на станции
=end

# Только start является публичным интферфейсом, потому что все остальное это реализация, но не интерфейс который доступен извне

require_relative 'train'
require_relative 'route'
require_relative 'station'
require_relative 'cargo_train'
require_relative 'passenger_train'

class App
  def initialize()
    @routes = []
    @trains = []
    @stations = []
  end

  def start()
    show_main_menu
    signal = get_user_input
    execute_main_menu_command(signal)
  end

  private
  def show_main_menu
    puts '
      Welcome to the dispatch center.

      1. Create [s]tation
      2. Create [t]rain
      3. Create [r]oute
      4. Modif[y] route
      5. Set [u]p train route
      6. [A]ttach wagon
      7. [D]etach wagon
      8. [M]ove train
      9. Show station [l]ist
      10. Show trains list [o]n the station
    '
  end

  def get_user_input()
    puts 'Waiting for your command (Number of list item/Hotkey):'
    gets.chomp
  end

  def execute_main_menu_command(signal)
    case signal
    when '1', 's', 'create station'
      puts 'Input station name and/or press enter'
      station_name = gets.chomp
      create_station(station_name.empty? ? random_station_name : station_name)

      print_indexed_list(@stations)

      start
    when '2', 't', 'create train'
      puts 'Input train type (cargo/passenger) and press enter'
      train_type = gets.chomp
      create_train(train_type, rand(1_000_000))

      print_indexed_list(@trains)

      start
    when '3', 'r', 'create route'
      puts 'Choose starting station number and press enter'
      print_indexed_list(@stations)
      starting_station_input = gets.chomp
      starting_station = @stations[starting_station_input.to_i]

      puts 'Choose final station number and press enter'
      print_indexed_list(@stations)
      final_station_input = gets.chomp
      final_station = @stations[final_station_input.to_i]

      create_route(starting_station, final_station) if starting_station && final_station

      print_indexed_list(@routes)

      start
    when '4', 'y', 'modify route'
      puts 'Choose route to modify'

      print_indexed_list(@routes)

      route_index = gets.chomp.to_i
      modifying_route = @routes[route_index]

      puts 'Do you want to delete station or to add? Type add or delete'

      action_type = gets.chomp

      if action_type == 'add'
        puts 'Choose station to add'

        available_stations = @stations - modifying_route.get_stations_list

        print_indexed_list(available_stations)

        adding_station_index = gets.chomp.to_i
        adding_station = available_stations[adding_station_index]

        if adding_station
          modifying_route.add_station(adding_station)
          puts "Station #{adding_station.name} added successfully."
        else
          puts "Invalid selection."
        end

      elsif action_type == 'delete'
        puts 'Choose station to delete (cannot remove first or last station):'

        removable_stations = modifying_route.get_stations_list[1..-2]

        if removable_stations.empty?
          puts "No stations available for removal."
        else
          print_indexed_list(removable_stations)

          deleting_station_index = gets.chomp.to_i
          deleting_station = removable_stations[deleting_station_index]

          if deleting_station
            modifying_route.remove_station(deleting_station)
            puts "Station #{deleting_station.name} removed successfully."
          else
            puts "Invalid selection."
          end
        end
      else
        puts "Unknown action."
      end

      print_indexed_list(modifying_route.get_stations_list)
      start
    end
  end

  def create_station(name)
    @stations << Station.new(name)
  end

  def create_train(type, number)
    newTrain = type == 'cargo' ? CargoTrain.new(number) : PassengerTrain.new(number)
    @trains << newTrain
  end

  def create_route(starting_station, final_station)
    newRoute = Route.new(starting_station, final_station)
    @routes << newRoute
  end

  def random_station_name
    prefixes = [
      "Central", "Grand", "Union", "City", "Metro", "North", "South", "East", "West", "Main"
    ]
    suffixes = [
      "Station", "Terminal", "Depot", "Stop", "Hub"
    ]

    prefix = prefixes.sample
    suffix = suffixes.sample

    "#{prefix} #{suffix}"
  end

  def print_indexed_list(array)
    array.each_with_index do |item, index|
      identifier = item.respond_to?(:name) ? item.name : item.number
      puts "#{index}. #{identifier}"
    end
  end
end

app = App.new

app.start
