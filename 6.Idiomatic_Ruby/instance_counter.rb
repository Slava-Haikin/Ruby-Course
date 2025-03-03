# The InstanceCounter module provides functionality to count instances of a class.
# It includes methods to increment and retrieve the instance count.

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    def instances
      @instances ||= 0
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
