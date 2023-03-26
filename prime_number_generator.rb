# frozen_string_literal: true

require 'prime'

class PrimeNumberGenerator
  def initialize(length:)
    @length = length
  end

  def generate_new_prime
    random_number = rand(length)
    loop do
      return random_number if Prime.prime?(random_number)

      random_number += 1
    end
  end

  attr_reader :length
end
