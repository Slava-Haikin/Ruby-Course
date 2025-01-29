class Wagon
  def initialize(type)
    if ['cargo', 'passenger'].include?(type)
      @type = type
    else
      raise "Error: Wagon can be only Freight or Passenger"
    end
  end
end
