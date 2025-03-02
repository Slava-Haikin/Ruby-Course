class PassengerWagon < Wagon
  attr_reader :total_seats, :occupied_seats

  def initialize
    super('passenger')

    @total_seats = 70
    @occupied_seats = 0
  end

  def occupy_seat
    return if (@total_seats - @occupied_seats).zero?

    @occupied_seats += 1
  end

  def available_seats
    @total_seats - @occupied_seats
  end
end
