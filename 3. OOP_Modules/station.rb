# В классе Station (жд станция) создать метод класса all, который возвращает все станции (объекты), созданные на данный момент

class Station
  attr_reader :trains, :name
  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@instances << self
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
end
