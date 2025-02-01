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

require_relative 'train'
require_relative 'route'
require_relative 'station'
require_relative 'cargo_train'
require_relative 'passenger_train'

class App
  def initialize()
    @train = nil
    @route = nil
    @available_stations = []
  end

  def start()
    show_main_menu
    signal = get_user_input
    execute_command(signal)
  end

  private
  def show_main_menu
    puts '
      Welcome to the dispatch center.

      1. Create [s]tation
      2. Create [t]rain
      3. Create [r]oute and modify route stations
      4. Set [u]p train route
      5. [A]ttach wagon
      6. [D]etach wagon
      7. [M]ove train
      8. Show station [l]ist
      9. Show train list [o]n the station
    '
  end

  def get_user_input()
    puts 'Waiting for your command (Number of list item/Hotkey):'
    gets.chomp
  end

  def execute_command(signal)
    case signal
    when '1' || 's'
      puts 'Input station name and/or press enter'
      name = gets.chomp

      create_station(name.empty? ? random_station_name : name)
      print @available_stations
      start
    end
  end

  def create_station(name)
    @available_stations << Station.new(name)
  end

  # def create_train()

  # end

  # def create_route_with_stations()

  # end

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
end

app = App.new

app.start
