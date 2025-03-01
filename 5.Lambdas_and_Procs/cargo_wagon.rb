=begin
Для грузовых вагонов:
  - Добавить атрибут общего объема (задается при создании вагона)
  - Добавить метод, которые "занимает объем" в вагоне (объем указывается в качестве параметра метода)
  - Добавить метод, который возвращает занятый объем
  - Добавить метод, который возвращает оставшийся (доступный) объем
  - При создании вагона указывать кол-во мест или общий объем, в зависимости от типа вагона
=end

class CargoWagon < Wagon
  attr_reader :total_volume, :occupied_volume, :measure_unit

  def initialize
    super('cargo')

    @total_volume = 138
    @occupied_volume = 0
    @measure_unit = 'm3'
  end

  def print_total_volume = print "#{@total_volume}#{@measure_unit}"
  def available_volume = @total_volume - @occupied_volume

  def load_cargo(volume)
    return if available_volume < volume

    @occupied_volume += volume
  end

  def unload_cargo(volume)
    return if @occupied_volume < volume

    @occupied_volume -= volume
  end
end
