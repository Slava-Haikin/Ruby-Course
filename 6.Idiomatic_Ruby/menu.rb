# frozen_string_literal: true

# The App class provides a command-line interface for App.
# It includes methods to print the menu, select the menu option, print the result.

class Menu
  MENU = [
    { id: 1, commands: ['s', 'add station'], action: :add_station, title: ' Add station' },
    { id: 2, commands: ['t', 'add train'], action: :add_train, title: ' Add train' },
    { id: 3, commands: ['r', 'add route'], action: :add_route, title: ' Add route' },
    { id: 4, commands: ['y', 'update route'], action: :update_route, title: ' Update route' },
    { id: 5, commands: ['u', 'assign route'], action: :assign_route_to_train, title: ' Assign route to train' },
    { id: 6, commands: ['a', 'attach wagon'], action: :attach_wagon, title: ' Attach wagon' },
    { id: 7, commands: ['d', 'detach wagon'], action: :detach_wagon, title: ' Detach wagon' },
    { id: 8, commands: ['m', 'move train'], action: :move_train, title: ' Move train' },
    { id: 9, commands: ['l', 'list stations'], action: :list_stations, title: ' Show stations list' },
    { id: 10, commands: ['o', 'list trains'], action: :list_trains, title: 'Show trains list' },
    { id: 11, commands: ['g', 'list wagons'], action: :list_train_wagons, title: 'Show train wagons list' },
    { id: 12, commands: ['i', 'load wagon'], action: :load_wagon, title: 'Load specific wagon' },
    { id: 0, commands: %w[E e exit], action: :exit, title: ' Exit' }
  ].freeze

  def display_menu
    menu_rows = MENU.map { |item| "#{item[:id]}. #{item[:title]}" }

    puts "\nWelcome to the dispatch center.\n\n"
    puts menu_rows.join("\n")
    puts "\n\n"
  end

  def display_list(array, message = nil)
    numbered_list = array.map { |item, _index| item.respond_to?(:name) ? item.name : item.number }

    puts "\n"
    puts message if message
    puts "=======================\n"
    puts numbered_list
    puts "=======================\n\n\n"
  end

  def prompt_user(message: nil, to_number: false)
    print message if message
    input = gets.chomp

    to_number ? input.to_i : input
  end

  def handle_user_selection
    command = prompt_user(message: 'Enter your command:')
    find_menu_action(command)
  end

  def find_menu_action(command)
    menu_item = MENU.find { |item| item[:commands].include?(command) || command.to_i == item[:id] }

    if menu_item
      menu_item[:action]
    else
      puts 'Invalid command. Please try again.'
    end
  end
end
