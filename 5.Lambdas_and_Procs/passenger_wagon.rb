=begin
Для пассажирских вагонов:
  - Добавить атрибут общего кол-ва мест (задается при создании вагона)
  - Добавить метод, который "занимает места" в вагоне (по одному за раз)
  - Добавить метод, который возвращает кол-во занятых мест в вагоне
  - Добавить метод, возвращающий кол-во свободных мест в вагоне.
=end

class PassengerWagon < Wagon
  attr_reader :total_seats, :occupied_seats

  def initialize
    super('passenger')

    @total_seats = 40
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
