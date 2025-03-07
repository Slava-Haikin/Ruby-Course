# frozen_string_literal: true
# Accessors module provides a set of methods to mix in dynamic methods into other classes

# Написать модуль Acсessors, содержащий следующие методы, которые можно вызывать на уровне класса:
#  Метод attr_accessor_with_history:
#  - Этот метод динамически создает геттеры и сеттеры для любого кол-ва атрибутов, при этом сеттер сохраняет все значения 
#    инстанс-переменной при изменении этого значения. 
#  - Также в класс, в который подключается модуль должен добавляться инстанс-метод <имя_атрибута>_history который возвращает 
#    массив всех значений данной переменной.
#  Метод strong_attr_accessor:
#  - Который принимает имя атрибута и его класс. При этом создается геттер и сеттер для одноименной инстанс-переменной, 
#    но сеттер проверяет тип присваемоего значения. Если тип отличается от того, который указан вторым параметром, то выбрасывается исключение. Если тип совпадает, то значение присваивается.

module Acсessors
  def attr_accessor_with_history(*args)
    args.each do |arg|
      define_method(arg) do
        instance_variable_get("@#{arg}")
      end

      define_method("#{arg}=") do |value|
        old_value = instance_variable_get("@#{arg}")
        history = instance_variable_get("@#{arg}_history") || []
        history << old_value if old_value

        instance_variable_set("@#{arg}_history", history)
        instance_variable_set("@#{arg}", value)
      end

      define_method("#{arg}_history") do
        instance_variable_get("@#{arg}_history") || []
      end
    end
  end

  def strong_attr_accessor(attr_name, class)
    puts 'Hello, World!'
  end
end
