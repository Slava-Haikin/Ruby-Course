# frozen_string_literal: true

require_relative 'route'

class RouteManager
  attr_reader :routes

  def initialize(menu, station_manager)
    @menu = menu
    @routes = []
    @station_manager = station_manager
  end

  def add_route
    @menu.display_list(@station_manager.stations, 'Select start station:')
    start_station = @station_manager.stations[@menu.prompt_user(to_number: true)]

    @menu.display_list(@station_manager.stations - [start_station], 'Select end station:')
    end_station = @station_manager.stations[@menu.prompt_user(to_number: true)]

    return puts 'Invalid station selection' unless start_station && end_station

    @routes << Route.new(start_station, end_station)
    @menu.display_list(@routes, 'Routes:')
  end
end
