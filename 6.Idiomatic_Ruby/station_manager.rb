# frozen_string_literal: true

require_relative 'station'

class StationManager
  attr_reader :stations

  def initialize(menu)
    @menu = menu
    @stations = []
  end

  def add_station
    station_name = @menu.prompt_user(message: 'Enter station name:')
    @stations << Station.new(station_name)
    @menu.display_list(@stations, 'Stations:')
  end

  def list_trains
    @menu.display_list(@stations, 'Select a station:')
    station = @stations[@menu.prompt_user(to_number: true)]

    return puts 'Invalid station selection' unless station

    station.each_train { |train| puts train.number }
  end
end
