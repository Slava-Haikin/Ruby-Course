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
    @initialized = false
  end

  def start()
    loop do
      if @initialized
        get_user_input 'To continue press "Enter"'
      end

      show_menu
      command = get_user_input 'Enter your command:'
      execute_menu_command(command)
      @initialized = false
    end
  end

  private
  def show_menu
    puts '
      Welcome to the dispatch center.

      1.  Create [s]tation
      2.  Create [t]rain
      3.  Create [r]oute
      4.  Modif[y] route
      5.  Set [u]p train route
      6.  [A]ttach wagon
      7.  [D]etach wagon
      8.  [M]ove train
      9.  Show station [l]ist
      10. Show trains list [o]n the station
      0.  [E]xit
    '
  end

  def get_user_input(message = nil)
    puts message if message
    gets.chomp
  end

  def execute_menu_command(command)
    case command
    when '1', 's', 'create station' then create_station
    when '2', 't', 'create train' then create_train
    when '3', 'r', 'create route' then create_route
    when '4', 'y', 'modify route' then modify_route
    when '5', 'y', 'set route' then set_train_route
    when '6', 'y', 'attach wagon' then attach_wagon
    when '7', 'y', 'detach wagon' then detach_wagon
    when '8', 'm', 'move train' then move_train
    when '9', 'l', 'stations list' then stations_list
    when '10', 'o', 'trains list' then trains_list
    when '0', 'E' then exit
    end
  end

  def create_station()
    station_name = get_user_input('Input station name and/or press enter:')

    @stations << Station.new(station_name.empty? ? random_station_name : station_name)

    print_list(@stations, 'New stations list:')
  end

  def create_train()
    train_type = get_user_input 'Input train type (cargo/passenger) and press enter:'
    train_number = rand(1_000_000)

    newTrain = train_type == 'cargo' ? CargoTrain.new(train_number) : PassengerTrain.new(train_number)
    @trains << newTrain

    print_list(@trains, 'New train list:')
  end

  def create_route()
    print_list(@stations)
    starting_station_index = get_user_input('Choose starting station number and press enter').to_i
    starting_station = @stations[starting_station_index]

    print_list(@stations - [starting_station])
    final_station_index = get_user_input('Choose final station number and press enter').to_i

    final_station = @stations[final_station_index]

    if starting_station.nil? || final_station.nil?
      puts 'Route was not created, please try again.'
      return
    end

    newRoute = Route.new(starting_station, final_station)
    @routes << newRoute
    print_list(@routes)
  end

  def modify_route()
    print_list(@routes)

    route_index = get_user_input('Choose route number to modify:').to_i
    modifying_route = @routes[route_index]

    action_type = get_user_input 'Do you want add or delete station?'
    case action_type
    when 'add'
      available_stations = @stations - modifying_route.get_stations_list

      print_list(available_stations, 'Choose station to add')

      adding_station_index_input = get_user_input
      adding_station = available_stations[adding_station_index_input.to_i]

      if adding_station
        modifying_route.add_station(adding_station)
        puts "Station #{adding_station.name} added successfully."
      else
        puts "Invalid selection."
      end
    when 'delete'
      puts 'Choose station to delete (cannot remove first or last station):'

      removable_stations = modifying_route.get_stations_list[1..-2]

      if removable_stations.empty?
        puts "No stations available for removal."
      else
        print_list(removable_stations)

        deleting_station_index_input = get_user_input
        deleting_station = removable_stations[deleting_station_index_input.to_i]

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

    print_list(modifying_route.get_stations_list)
  end

  def set_train_route()
    print_list(@trains, 'Trains:')
    modifying_train_index = get_user_input('Choose a train number to set up the route:').to_i
    modifying_train = @trains[modifying_train_index]

    unless modifying_train
      puts 'Not an existing train'
      return
    end

    print_list(@routes, 'Routes:')
    adding_route_index = get_user_input('Choose a route to add:').to_i
    adding_route = @trains[adding_route_index]

    unless adding_route
      puts 'Not an existing route'
      return
    end

    modifying_train.set_route(adding_route)
    puts 'Route was added!'
  end

  def attach_wagon
    print_list(@trains, 'Choose a train to attach a wagon:')
    train_index = get_user_input.to_i
    train = @trains[train_index]

    unless train
      puts 'Invalid train selection'
      return
    end

    wagon = train.type == :cargo ? CargoWagon.new : PassengerWagon.new
    train.attach_wagon(wagon)

    puts "Wagon successfully attached to train #{train.number}"
  end

  def detach_wagon
    print_list(@trains, 'Choose a train to detach a wagon:')
    train_index = get_user_input.to_i
    train = @trains[train_index]

    unless train
      puts 'Invalid train selection'
      return
    end

    if train.wagons.empty?
      puts 'No wagons to detach.'
    else
      train.detach_wagon
      puts "Wagon successfully detached from train #{train.number}"
    end
  end

  def move_train
    print_list(@trains, 'Choose a train to move:')
    train_index = get_user_input.to_i
    train = @trains[train_index]

    unless train
      puts 'Invalid train selection'
      return
    end

    direction = get_user_input('Enter direction (forward/backward):')

    case direction
    when 'forward'
      train.move_forward
      puts "Train #{train.number} moved forward."
    when 'backward'
      train.move_backward
      puts "Train #{train.number} moved backward."
    else
      puts 'Invalid direction.'
    end
  end

  def stations_list
    print_list(@stations, 'List of stations:')
  end

  def trains_list
    print_list(@stations, 'Choose a station:')
    station_index = get_user_input.to_i
    station = @stations[station_index]

    unless station
      puts 'Invalid station selection'
      return
    end

    print_list(station.trains, "Trains at #{station.name}:")
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

  def print_list(array, message = nil)
    if (message)
      puts message
    end

    puts "=======================\n"
    array.each_with_index do |item, index|
      identifier = item.respond_to?(:name) ? item.name : item.number
      puts "#{index}. #{identifier}"
    end
    puts "=======================\n\n\n"
  end
end

app = App.new

app.start
