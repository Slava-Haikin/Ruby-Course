module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    def instances
      @instances ||=0
    end

    def increment_instances
      @instances = instances + 1 
    end
  end

  module InstanceMethods
    def register_instance
      self.class.increment_instances
    end
  end
end