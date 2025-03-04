# frozen_string_literal: true

require_relative 'route'

class RouteManager
  def initialize(menu)
    @menu = menu
    @routes = []
  end

  def add_route
    @menu.display_list(@stations, 'Select start station:')
    start_station = @stations[@menu.prompt_user(to_number: true)]

    @menu.display_list(@stations - [start_station], 'Select end station:')
    end_station = @stations[@menu.prompt_user(to_number: true)]

    return puts 'Invalid station selection' unless start_station && end_station

    @routes << Route.new(start_station, end_station)
    @menu.display_list(@routes, 'Routes:')
  end
end
