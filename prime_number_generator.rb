# frozen_string_literal: true

require 'prime'

class PrimeNumberGenerator
  def initialize(length:)
    @length = length
  end

  def generate_new_prime
    random_number = rand(2**length)
    loop do
      return random_number if Prime.prime?(random_number, Prime::MillerRabin.new)

      random_number += 1
    end
  end

  attr_reader :length
end
