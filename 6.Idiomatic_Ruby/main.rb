# frozen_string_literal: true

# The App class provides a command-line interface for managing trains, stations, and routes.
# It includes methods to create and modify these objects, as well as to interact with the user through a menu system.
require_relative 'instance_counter'
require_relative 'manufacturer'

require_relative 'menu'
require_relative 'train_manager'
require_relative 'route_manager'
require_relative 'station_manager'
require_relative 'wagon_manager'

class App
  ACTIONS = {
    add_train: :add_train,
    add_route: :add_route,
    add_station: :add_station,
    assign_route: :assign_route_to_train,
    attach_wagon: :attach_wagon,
    detach_wagon: :detach_wagon,
    list_trains: :list_trains,
    list_wagons: :list_wagons
  }.freeze

  def initialize
    @menu = Menu.new
    @station_manager = StationManager.new(@menu)
    @route_manager = RouteManager.new(@menu, @station_manager)
    @train_manager = TrainManager.new(@menu, @route_manager)
    @wagon_manager = WagonManager.new(@menu, @train_manager)
  end

  def start
    loop do
      @menu.display_menu
      action = @menu.handle_user_selection
      run_action(action)
    end
  end

  private

  def run_action(action)
    manager = find_manager(action)
    method = ACTIONS[action]

    if manager && method
      manager.public_send(method)
    else
      puts 'Unknown command'
    end
  end

  def find_manager(action)
    case action
    when :add_train, :assign_route then @train_manager
    when :add_route then @route_manager
    when :add_station, :list_trains then @station_manager
    when :attach_wagon, :detach_wagon, :list_wagons then @wagon_manager
    end
  end
end

App.new.start
