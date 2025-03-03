# frozen_string_literal: true

# The CargoWagon class represents a cargo wagon with a specific total and occupied volume.
# It inherits from the Wagon class and provides methods to load and unload cargo, as well as to check available volume.

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
