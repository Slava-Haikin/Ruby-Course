# frozen_string_literal: true

require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'

class TrainManager
  def initialize(menu)
    @menu = menu
    @trains = []
  end

  def add_train
    train_type = @menu.prompt_user(message: 'Enter train type (cargo/passenger):')
    train_number = @menu.prompt_user(message: 'Enter train number:')

    train = case train_type
            when 'cargo' then CargoTrain.new(train_number)
            when 'passenger' then PassengerTrain.new(train_number)
            else puts 'Invalid train type'
            end

    @trains << train if train
    @menu.display_list(@trains, 'Trains:')
  end

  def assign_route_to_train
    @menu.display_list(@trains, 'Select a train:')
    train = @trains[@menu.prompt_user(to_number: true)]

    return puts 'Invalid train selection' unless train

    @menu.display_list(@routes, 'Select a route:')
    route = @routes[@menu.prompt_user(to_number: true)]

    return puts 'Invalid route selection' unless route

    train.set_route(route)
    puts 'Route assigned successfully!'
  end
end
