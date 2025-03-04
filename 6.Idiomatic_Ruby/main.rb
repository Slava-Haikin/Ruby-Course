# frozen_string_literal: true

# The App class provides a command-line interface for managing trains, stations, and routes.
# It includes methods to create and modify these objects, as well as to interact with the user through a menu system.
require_relative 'menu'
require_relative 'manufacturer'
require_relative 'instance_counter'

require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

require_relative 'route'
require_relative 'station'

require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'

class App
  def initialize
    @initialized = false
    @menu = Menu.new
    @routes = []
    @trains = []
    @stations = []
  end

  def start
    loop do
      @menu.prompt_user(message: 'To continue press "Enter"') if @initialized
      @menu.display_menu

      @initialized = false

      action = @menu.handle_user_selection
      run_action(action)
    end
  end

  private

  def run_action(action)
    if action
      send(action)
    else
      puts 'Invalid action. Please try again.'
    end
  end

  def add_station
    station_name = @menu.prompt_user(message: 'Input station name and/or press enter:')

    @stations << Station.new(station_name.empty? ? random_station_name : station_name)

    @menu.display_list(@stations, 'New stations list:')
  end

  def add_train
    # attempts = 0

    # begin
    #   attempts += 1

    train_type = @menu.prompt_user(message: 'Input train type (cargo/passenger) and press enter:')
    train_number = @menu.prompt_user(message: 'Input train number (E.g. 123-23) and press enter:')

    new_train = if train_type == 'cargo'
                  CargoTrain.new(train_number,
                                 train_type)
                else
                  PassengerTrain.new(train_number, train_type)
                end
    @trains << new_train

    @menu.display_list(@trains, 'New train list:')
    # rescue StandardError => e
    #   puts "Error: #{e.message}. Please try again."
    #   retry if attempts < 5
    # end
  end

  def add_route
    @menu.display_list(@stations)
    starting_station_index = @menu.prompt_user(message: 'Choose starting station number and press enter',
                                               to_number: true)
    starting_station = @stations[starting_station_index]

    @menu.display_list(@stations - [starting_station])
    final_station_index = @menu.prompt_user(message: 'Choose final station number and press enter', to_number: true)

    final_station = @stations[final_station_index]

    if starting_station.nil? || final_station.nil?
      puts 'Route was not created, please try again.'
      return
    end

    new_route = Route.new(starting_station, final_station)
    @routes << new_route
    @menu.display_list(@routes)
  end

  def update_route
    @menu.display_list(@routes, 'Choose a route to modify:')
    route_index = @menu.prompt_user.to_i
    modifying_route = @routes[route_index]

    unless modifying_route
      puts 'Invalid route selection.'
      return
    end

    action_type = @menu.prompt_user(message: 'Do you want to add or delete a station? (add/delete):').strip.downcase

    case action_type
    when 'add' then add_station_to_route(modifying_route)
    when 'delete' then delete_station_from_route(modifying_route)
    else
      puts 'Unknown action.'
    end

    @menu.display_list(modifying_route.get_stations_list, 'Updated route stations:')
  end

  def add_station_to_route(route)
    available_stations = @stations - route.get_stations_list
    if available_stations.empty?
      puts 'No available stations to add.'
      return
    end

    @menu.display_list(available_stations, 'Choose a station to add:')
    station_index = @menu.prompt_user.to_i
    station = available_stations[station_index]

    if station
      route.add_station(station)
      puts "Station #{station.name} added successfully."
    else
      puts 'Invalid selection.'
    end
  end

  def delete_station_from_route(route)
    removable_stations = route.get_stations_list[1..-2]
    if removable_stations.empty?
      puts 'No stations available for removal.'
      return
    end

    @menu.display_list(removable_stations, 'Choose a station to delete:')
    station_index = @menu.prompt_user.to_i
    station = removable_stations[station_index]

    if station
      route.remove_station(station)
      puts "Station #{station.name} removed successfully."
    else
      puts 'Invalid selection.'
    end
  end

  def assign_route_to_train
    @menu.display_list(@trains, 'Trains:')
    modifying_train_index = @menu.prompt_user(message: 'Choose a train number to set up the route:', to_number: true)
    modifying_train = @trains[modifying_train_index]

    unless modifying_train
      puts 'Not an existing train'
      return
    end

    @menu.display_list(@routes, 'Routes:')
    adding_route_index = @menu.prompt_user(message: 'Choose a route to add:', to_number: true)
    adding_route = @routes[adding_route_index]

    unless adding_route
      puts 'Not an existing route'
      return
    end

    modifying_train.set_route(adding_route)
    puts 'Route was added!'
  end

  def attach_wagon
    @menu.display_list(@trains, 'Choose a train to attach a wagon:')

    train_index = @menu.prompt_user(to_number: true)
    train = @trains[train_index]
    cargo_train = train.type == 'cargo'

    unless train
      puts 'Invalid train selection'
      return
    end

    print

    wagon = cargo_train ? CargoWagon.new : PassengerWagon.new
    train.attach_wagon(wagon)

    puts "Wagon successfully attached to train #{train.number}"
  end

  def detach_wagon
    @menu.display_list(@trains, 'Choose a train to detach a wagon:')
    train_index = @menu.prompt_user(to_number: true)
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
    @menu.display_list(@trains, 'Choose a train to move:')
    train_index = @menu.prompt_user(to_number: true)
    train = @trains[train_index]

    unless train
      puts 'Invalid train selection'
      return
    end

    direction = @menu.prompt_user(message: 'Enter direction (forward/backward):')

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

  def list_stations
    @menu.display_list(@stations, 'List of stations:')
  end

  def list_trains
    @menu.display_list(@stations, 'Choose a station:')
    station_index = @menu.prompt_user(to_number: true)
    station = @stations[station_index]

    unless station
      puts 'Invalid station selection'
      return
    end

    puts "Trains at #{station.name}:"
    station.each_train { |_train| puts trains.number }
  end

  def list_wagons
    @menu.display_list(@trains, 'Choose a train to show its wagons:')
    train_index = @menu.prompt_user(to_number: true)
    train = @trains[train_index]

    unless train
      puts 'Invalid train selection'
      return
    end

    puts "Wagons attached to train #{train.number}:"
    train.each_wagon { |wagon| puts wagon }
  end

  def load_wagon
    @menu.display_list(@trains, 'Choose a train to show its wagons:')
    train_index = @menu.prompt_user(to_number: true)
    train = @trains[train_index]

    unless train
      puts 'Invalid train selection'
      return
    end

    @menu.display_list(train.wagons, 'Choose a wagon to load it:')
    wagon_index = @menu.prompt_user(to_number: true)
    wagon = train.wagons[wagon_index]

    unless wagon
      puts 'Invalid wagon selection'
      return
    end

    cargo_train = train.type == 'cargo'

    if cargo_train
      puts "What is the cargo volume? Available space is: #{wagon.available_volume}"
      cargo_volume = @menu.prompt_user(to_number: true)
      space_enough = cargo_volume <= wagon.available_volume

      if space_enough
        wagon.load_cargo(cargo_volume)
        puts "Cargo loaded! Volume available: #{wagon.available_volume}"
      else
        puts "Not enough space! Volume available: #{wagon.available_volume}"
      end
    else
      result = wagon.occupy_seat
      successfully_booked_text = result "You successfully booked a seat on #{wagon.number}.
      Seats left: #{wagon.available_seats}"
      no_seats_text = 'No seats available, sorry'

      puts(result ? successfully_booked_text : no_seats_text)
    end
  end

  def random_station_name
    existing_names = @stations.map(&:name)

    loop do
      prefix = %w[Central Grand Union City Metro North South East West Main].sample
      suffix = %w[Station Terminal Depot Stop Hub].sample

      name = "#{prefix} #{suffix}"
      return name unless existing_names.include?(name)
    end
  end
end

app = App.new

app.start
