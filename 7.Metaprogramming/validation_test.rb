# frozen_string_literal: true

# The Train class with mixed-in validation module.
require_relative 'validation'

correct_train_number = '123-23'
correct_train_type = 'cargo'

# Should pass
train = Train.new(correct_train_number, correct_train_type)

print train
