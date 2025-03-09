# frozen_string_literal: true

# The Train class with mixed-in validation module.
require_relative 'validation'
require_relative '../6.Idiomatic_Ruby/instance_counter'
require_relative '../6.Idiomatic_Ruby/manufacturer'

class Train
  include InstanceCounter
  include Manufacturer
  include Validation

  attr_accessor :speed, :type
  attr_reader :wagons, :number, :route

  TRAIN_NUMBER_FORMAT = /^[a-zA-Z0-9]{3}-?[a-zA-Z0-9]{2}$/
  TRAIN_TYPES = %w[cargo passenger].freeze

  validate :number, :format, TRAIN_NUMBER_FORMAT
  validate :type, :type, String
  validate :type, :presence

  def initialize(number, type)
    @number = number
    @type = type
    @route = nil
    @wagons = []
    @speed = 0
    @route_station_index = 0

    validate!
    register_instance if defined?(register_instance)
  end

  def route=(route)
    @route = route
    @route_station_index = 0 if route
  end

  def accelerate(acceleration)
    @speed += acceleration
  end

  def brake
    @speed = 0
  end

  def attach_wagon(wagon)
    raise 'Error: Cannot attach wagon while train is moving' unless @speed.zero?
    raise 'Error: Wagon type mismatch' unless wagon.respond_to?(:type) && wagon.type == @type

    @wagons << wagon
  end

  def detach_wagon
    unless @speed.zero? && @wagons.length.positive?
      raise 'Error: Cannot detach wagon while train is moving or no wagons to detach'
    end

    @wagons.pop
  end

  def current_station
    @route&.show_station_by_number&.[](@route_station_index)
  end

  def next_station
    return unless @route

    last_station_index = @route.stations.size - 1
    @route.stations[@route_station_index + 1] if @route_station_index < last_station_index
  end

  def previous_station
    return unless @route && @route_station_index.positive?

    @route.stations[@route_station_index - 1]
  end

  def move_forward
    raise 'Error: No route assigned' unless @route
    raise 'Error: No more stations to move forward' unless @route_station_index < @route.stations.size - 1

    @route_station_index += 1
  end

  def move_backward
    raise 'Error: No previous station to move backward' unless route || @route_station_index.positive?

    @route_station_index -= 1
  end

  def each_wagon(&block)
    @wagons.each(&block) if block_given?
  end
end
