# frozen_string_literal: true

# Validate module provides a set of validate methods to check instance data

# Содержит метод класса validate.
# Этот метод принимает в качестве параметров имя проверяемого атрибута, а также тип валидации и
# при необходимости дополнительные параметры.
# Возможные типы валидаций:
#   - presence: требует, чтобы значение атрибута было не nil и не пустой строкой.
#     Пример использования: validate :name, :presence
#   - format (при этом отдельным параметром задается регулярное выражение для формата).
#     Требует соответствия значения атрибута заданному
#     регулярному выражению.
#     Пример:  validate :number, :format, /A-Z{0,3}/
#   - type (третий параметр - класс атрибута). Требует соответствия значения атрибута заданному классу.
#     Пример: validate :station, :type, RailwayStation

# Содержит инстанс-метод validate!, который запускает все проверки (валидации), указанные в классе через
# метод класса validate.
# В случае ошибки валидации выбрасывает исключение с сообщением о том, какая именно валидация не прошла
# Содержит инстанс-метод valid? который возвращает true, если все проверки валидации прошли успешно и false,
# если есть ошибки валидации.
# К любому атрибуту можно применить несколько разных валидаторов, например:
# 1) validate :name, :presence
# 2) validate :name, :format, /A-Z/
# 3) validate :name, :type, String
# 4) Все указанные валидаторы должны применяться к атрибуту
# 5) Допустимо, что модуль не будет работать с наследниками.

module Validation
  VALIDATOR_TYPES = %s(presence format type)

  def self.extended(base)
    base.instance_variable_set(:@validators, [])
  end

  def validate(_attr_name, validator, option = nil)
    @validators << { attr_name: attr_name, validator: validator, option: option }
  end

  def validate!
    self.class.instance_variable_get(:@validators).each do |validator|
      value = instance_variable_get("@#{validator[:attr_name]}")
      case validator[:validator]
      when :presence then validate_presence(value)
      when :format   then validate_format(value, validator[:option])
      when :type     then validate_type(value, validator[:option])
      else raise "Unknown validation type: #{validator[:validator]}"
      end
    end
    true
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def validate_presence(property_value)
    raise 'Property value should be not empty or empty string' if property_value.nil? || property_value.strip.empty?

    true
  end

  def validate_format(property_value, format)
    raise 'Property value should not be nil or empty string' if property_value.nil? || property_value.strip.empty?
    raise "Property value does not match format #{format}" unless property_value.match?(format)
  
    true
  end

  def validate_type(property_value, expected_class)
    raise 'Property value should not be nil' if property_value.nil?
    raise "Expected #{expected_class}, got #{property_value.class}" unless property_value.is_a?(expected_class)
  
    true
  end  
end
