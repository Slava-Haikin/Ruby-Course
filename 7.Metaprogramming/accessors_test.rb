require_relative 'accessors'

class AccessorsTest
  include Accessors
end

AccessorsTest.attr_accessor_with_history(:test :another_test :final_test)
test = AccessorsTest.new

puts test.test
puts test.another_test
puts test.final_test