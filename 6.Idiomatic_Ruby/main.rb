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
  def initialize
    @menu = Menu.new
    @train_manager = TrainManager.new(@menu)
    @route_manager = RouteManager.new(@menu)
    @station_manager = StationManager.new(@menu)
    @wagon_manager = WagonManager.new(@menu)
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
    actions = {
      add_train: -> { @train_manager.add_train },
      add_route: -> { @route_manager.add_route },
      add_station: -> { @station_manager.add_station },
      assign_route: -> { @train_manager.assign_route_to_train },
      attach_wagon: -> { @wagon_manager.attach_wagon },
      detach_wagon: -> { @wagon_manager.detach_wagon },
      list_trains: -> { @station_manager.list_trains },
      list_wagons: -> { @wagon_manager.list_wagons }
    }

    actions.fetch(action, -> { puts 'Unknown command' }).call
  end
end

App.new.start

App.new.start
