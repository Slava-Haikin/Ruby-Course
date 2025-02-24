=begin
1) Реализовать проверку (валидацию) данных для всех классов. 
   Проверять основные атрибуты (название, номер, тип и т.п.) на наличие, длину и т.п. (в зависимости от атрибута):
     - Валидация должна вызываться при создании объекта, если объект невалидный, то должно выбрасываться исключение
     - Должен быть метод valid? который возвращает true, если объект валидный и false - в противном случае.

2) Релизовать проверку на формат номера поезда. Допустимый формат: три буквы или цифры в любом порядке, 
необязательный дефис (может быть, а может нет) и еще 2 буквы или цифры после дефиса.

3) Убрать из классов все puts (кроме методов, которые и должны что-то выводить на экран), методы просто возвращают значения. (Начинаем бороться за чистоту кода).
4) Релизовать простой текстовый интерфейс для создания поездов (если у вас уже реализован интерфейс, то дополнить его):
  - Программа запрашивает у пользователя данные для создания поезда (номер и другие необходимые атрибуты)
  - Если атрибуты валидные, то выводим информацию о том, что создан такой-то поезд
  - Если введенные данные невалидные, то программа должна вывести сообщение о возникших ошибках и заново запросить данные у пользователя. Реализовать это через механизм обработки исключений
=end

require_relative 'instance_counter'
require_relative 'manufacturer'
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

  MENU = [
    { id: 1, commands: %w[s create\ station], action: :create_station, title: "Create station" },
    { id: 2, commands: %w[t create\ train], action: :create_train, title: "Create train" },
    { id: 3, commands: %w[r create\ route], action: :create_route, title: "Create route" },
    { id: 4, commands: %w[y modify\ route], action: :modify_route, title: "Modify route" },
    { id: 5, commands: %w[u set\ route], action: :set_train_route, title: "Set train route" },
    { id: 6, commands: %w[a attach\ wagon], action: :attach_wagon, title: "Attach wagon" },
    { id: 7, commands: %w[d detach\ wagon], action: :detach_wagon, title: "Detach wagon" },
    { id: 8, commands: %w[m move\ train], action: :move_train, title: "Move train" },
    { id: 9, commands: %w[l stations\ list], action: :stations_list, title: "Show stations list" },
    { id: 10, commands: %w[o trains\ list], action: :trains_list, title: "Show trains list" },
    { id: 0, commands: %w[E e exit], action: :exit, title: "Exit" }
  ]


  def show_menu
    puts "\nWelcome to the dispatch center.\n\n"
    MENU.each { |item| puts "#{item[:id]}. #{item[:title]}" }
    puts "\n\n"
  end

  def get_user_input(message = nil)
    puts message if message
    gets.chomp
  end

  def execute_menu_command(command)
    menu_item = MENU.find { |item| item[:commands].include?(command) || command.to_i == item[:id] }

    if menu_item
      action = menu_item[:action]
      send(action)
    else
      puts 'Invalid command. Please try again.'
    end
  end


  def create_station()
    station_name = get_user_input('Input station name and/or press enter:')

    @stations << Station.new(station_name.empty? ? random_station_name : station_name)

    print_list(@stations, 'New stations list:')
  end

  def create_train
    loop do
      begin
        train_type = get_user_input 'Input train type (cargo/passenger) and press enter:'
        train_number = get_user_input 'Input train number (E.g. 123-23) and press enter:'
  
        new_train = train_type == 'cargo' ? CargoTrain.new(train_number, train_type) : PassengerTrain.new(train_number, train_type)
        @trains << new_train
  
        print_list(@trains, 'New train list:')
        break
  
      rescue StandardError => e
        puts "Error: #{e.message}. Please try again."
      end
    end
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

    new_route = Route.new(starting_station, final_station)
    @routes << new_route
    print_list(@routes)
  end

  def modify_route
    print_list(@routes, 'Choose a route to modify:')
    route_index = get_user_input.to_i
    modifying_route = @routes[route_index]

    unless modifying_route
      puts 'Invalid route selection.'
      return
    end

    action_type = get_user_input('Do you want to add or delete a station? (add/delete):').strip.downcase

    case action_type
    when 'add' then add_station_to_route(modifying_route)
    when 'delete' then delete_station_from_route(modifying_route)
    else
      puts 'Unknown action.'
    end

    print_list(modifying_route.get_stations_list, 'Updated route stations:')
  end

  def add_station_to_route(route)
    available_stations = @stations - route.get_stations_list
    if available_stations.empty?
      puts 'No available stations to add.'
      return
    end

    print_list(available_stations, 'Choose a station to add:')
    station_index = get_user_input.to_i
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

    print_list(removable_stations, 'Choose a station to delete:')
    station_index = get_user_input.to_i
    station = removable_stations[station_index]

    if station
      route.remove_station(station)
      puts "Station #{station.name} removed successfully."
    else
      puts 'Invalid selection.'
    end
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
    adding_route = @routes[adding_route_index]

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

    wagon = train.type == 'cargo' ? CargoWagon.new : PassengerWagon.new
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
    existing_names = @stations.map(&:name)

    loop do
      prefix = %w[Central Grand Union City Metro North South East West Main].sample
      suffix = %w[Station Terminal Depot Stop Hub].sample

      name = "#{prefix} #{suffix}"
      return name unless existing_names.include?(name)
    end
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
