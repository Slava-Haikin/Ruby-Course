=begin
  Создать модуль InstanceCounter, содержащий следующие методы класса и инстанс-методы, 
  которые подключаются автоматически при вызове include в классе:
  Методы класса:
      - instances, который возвращает кол-во экземпляров данного класса
  Инстанс-методы:
      - register_instance, который увеличивает счетчик кол-ва экземпляров класса и который можно вызвать из конструктора. При этом данный метод не должен быть публичным.
=end

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances
      @instances ||=0
    end

    def increment_instances
      @instances += 1
    end
  end

  module InstanceMethods
    def register_instance
      self.class.increment_instances
    end
  end
end