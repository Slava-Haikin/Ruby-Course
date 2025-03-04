# frozen_string_literal: true

require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class WagonManager
  def initialize(menu, train_manager)
    @menu = menu
    @train_manager = train_manager
  end

  def attach_wagon
    @menu.display_list(@train_manager.trains, 'Select a train:')
    train = @train_manager.trains[@menu.prompt_user(to_number: true)]

    return puts 'Invalid train selection' unless train

    wagon = train.type == 'cargo' ? CargoWagon.new : PassengerWagon.new
    train.attach_wagon(wagon)

    puts "Wagon attached to train #{train.number}"
  end

  def detach_wagon
    @menu.display_list(@train_manager.trains, 'Select a train:')
    train = @train_manager.trains[@menu.prompt_user(to_number: true)]

    return puts 'Invalid train selection' unless train
    return puts 'No wagons to detach' if train.wagons.empty?

    train.detach_wagon
    puts "Wagon detached from train #{train.number}"
  end

  def list_wagons
    @menu.display_list(@train_manager.trains, 'Select a train:')
    train = @train_manager.trains[@menu.prompt_user(to_number: true)]

    return puts 'Invalid train selection' unless train

    train.each_wagon { |wagon| puts wagon }
  end
end
