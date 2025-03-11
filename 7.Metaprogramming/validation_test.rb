# frozen_string_literal: true

# The Train class with mixed-in validation module.
require_relative 'train'

correct_train_number = '123-23'
correct_train_type = 'cargo'

# Should pass
train = Train.new(correct_train_number, correct_train_type)

puts train.number
puts train.type

# Sould not pass
# CASE 1: Empty values
begin
  wrong_train_number = ''
  wrong_train_type = ''
  trainee = Train.new(wrong_train_number, wrong_train_type)
rescue => e
  puts e
end

# CASE 2: Wrong train number format
begin
  wrong_train_number = '2'
  wrong_train_type = 'cargo'
  trainee = Train.new(wrong_train_number, wrong_train_type)
rescue => e
  puts e
end