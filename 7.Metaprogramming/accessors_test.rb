# frozen_string_literal: true

# Test class for Accessors
require_relative 'accessors'

class AccessorsTest
  extend Accessors
  attr_accessor_with_history(:test, :another_test, :final_test)
  strong_attr_accessor(:new_number, Integer)
end

test = AccessorsTest.new

# Should be empty
puts test.test
puts test.another_test
puts test.final_test

# Assign values
test.test = 'test'
test.another_test = 'another_test'
test.final_test = 'final_test'

# Should be equal to assigned values
puts test.test
puts test.another_test
puts test.final_test

# Re-assign values
test.test = 'test_1'
test.another_test = 'another_test_1'
test.final_test = 'final_test_1'

test.test = 'test_2'
test.another_test = 'another_test_2'
test.final_test = 'final_test_2'

# Each history should have two records
print test.test_history          # => ["test", "test_1"]
print test.another_test_history  # => ["another_test", "another_test_1"]
print test.final_test_history    # => ["final_test", "final_test_1"]

# Strong accessor test
# Should not raise an error
puts "\n\n"
test.new_number = 55
puts test.new_number

# Hazard! Should raise an error!
# test.new_number = 'Fifty five'