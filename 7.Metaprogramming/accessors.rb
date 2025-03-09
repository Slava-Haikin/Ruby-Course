# frozen_string_literal: true

# Accessors module provides a set of methods to mix in dynamic methods into other classes

# Написать модуль Acсessors, содержащий следующие методы, которые можно вызывать на уровне класса:
#  Метод attr_accessor_with_history:
#  - Этот метод динамически создает геттеры и сеттеры для любого кол-ва атрибутов, при этом сеттер
#    сохраняет все значения
#    инстанс-переменной при изменении этого значения.
#  - Также в класс, в который подключается модуль должен добавляться инстанс-метод <имя_атрибута>_history,
#    который возвращает массив всех значений данной переменной.
#  Метод strong_attr_accessor:
#  - Который принимает имя атрибута и его класс. При этом создается геттер и сеттер для одноименной инстанс-переменной,
#    но сеттер проверяет тип присваемоего значения. Если тип отличается от того, который указан вторым параметром,
#    то выбрасывается исключение. Если тип совпадает, то значение присваивается.

module Accessors
  def attr_accessor_with_history(*args)
    args.each do |arg|
      define_method(arg) { instance_variable_get("@#{arg}") }

      define_method("#{arg}=") do |value|
        old_value = instance_variable_get("@#{arg}")
        history = instance_variable_get("@#{arg}_history") || []
        history << old_value if old_value

        instance_variable_set("@#{arg}_history", history)
        instance_variable_set("@#{arg}", value)
      end

      define_method("#{arg}_history") { instance_variable_get("@#{arg}_history") || [] }
    end
  end

  def strong_attr_accessor(attribute_name, target_class)
    define_method(attribute_name) { instance_variable_get("@#{attribute_name}") }

    define_method("#{attribute_name}=") do |value|
      raise "Type mismatch: Expected #{target_class}, got #{value.class}" unless value.is_a?(target_class)

      instance_variable_set("@#{attribute_name}", value)
    end
  end
end
