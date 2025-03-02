class Station
  include InstanceCounter
  attr_reader :trains, :name
  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@instances << self

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
      raise ArgumentError, "Invalid train type: #{type}" unless ['cargo', 'passenger'].include?(type)
      @trains.select { |train| train.type == type }
  end

  def each_train
    @trains.each { |train| yield(train) } if block_given?
  end

  protected
  def valid?
    !@name.empty?
  end

  def validate!
    raise "Invalid station name" unless valid?
  end
end
