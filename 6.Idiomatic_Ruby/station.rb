# frozen_string_literal: true

# The Station class represents a train station with a specific name and a list of trains.
# It includes the InstanceCounter module to provide instance counting functionality.
# The class provides methods to manage the trains at the station, including receiving and dispatching trains,
# as well as retrieving trains by type and iterating over all trains.

class Station
  include InstanceCounter
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []

    validate!

    register_instance if respond_to?(:register_instance)
  end

  def receive_train(train)
    @trains.push(train)
  end

  def dispatch_train(train)
    @trains.delete(train)
  end

  def get_train_list_by_type(type)
    raise ArgumentError, "Invalid train type: #{type}" unless %w[cargo passenger].include?(type)

    @trains.select { |train| train.type == type }
  end

  def each_train(&block)
    @trains.each(&block) if block_given?
  end

  protected

  def valid?
    !@name.empty?
  end

  def validate!
    raise 'Invalid station name' unless valid?
  end
end
