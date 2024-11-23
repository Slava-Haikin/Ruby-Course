class Station
  attr_reader :trains

  def initialize(station_name)
    @station_name = station_name
    @trains = []
  end

  def receive_train(train)
    @trains.push(train)
  end

  def dispatch_train
    @trains.pop
  end

  def get_train_list_by_type(type)
    case type
    when 'passenger'
      @trains.filter
    when 'freight'
      @trains.filter
    else
      "Error: type has an invalid value (#{type})"
  end
end
