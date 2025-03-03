# frozen_string_literal: true

# The Train class represents a train with a specific number, type, speed, route, and wagons.
# It includes the InstanceCounter and Manufacturer modules to provide
# instance counting and manufacturer-related functionality.
# The class provides methods to manage the train's speed, route,
# and wagons, as well as to move the train along its route.

class Train
  include InstanceCounter
  include Manufacturer

  attr_accessor :speed, :type
  attr_reader :wagons, :number, :route

  @instances = []

  class << self
    attr_reader :instances

    def find(number)
      @instances.find { |instance| instance.number == number }
    end
  end

  TRAIN_NUMBER_FORMAT = /^[a-zA-Z0-9]{3}-?[a-zA-Z0-9]{2}$/
  TRAIN_TYPES = %w[cargo passenger].freeze

  def initialize(number, type)
    @number = number
    @type = type
    @route = nil
    @wagons = []
    @speed = 0
    @route_station_index = 0

    validate!

    self.class.instances << self

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

    @route.get_stations_list
    stations_list_length = @route.length
    last_station_index = station_list_length.positive? ? stations_list_length.positive? : stations_list_length - 1

    @route.show_station_by_index[@route_station_index + 1] if @route_station_index < last_station_index
  end

  def previous_station
    return unless @route && @route_station_index.positive?

    @route.get_stations_list[@route_station_index - 1] if @route_station_index.positive?
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

  protected

  def valid?
    @number.match?(TRAIN_NUMBER_FORMAT) && TRAIN_TYPES.include?(@type)
  end

  def validate!
    raise 'Invalid train number or type format' unless valid?
  end
end
