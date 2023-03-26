# frozen_string_literal: true

require 'json'
require 'rubocop'
require_relative 'prime_number_generator'

class RSAKeyGenerator

  def self.call(...) = new(...).call

  attr_accessor :p, :q, :n, :phi, :e, :d, :l

  def initialize(length:)
    @length = length / 2
    @e = 65537
    prime_generator = PrimeNumberGenerator.new(length: length)
    @p = prime_generator.generate_new_prime
    @q = prime_generator.generate_new_prime
  end

  def call
    calculate_n
    calculate_phi
    calculate_d
    puts 'save public_key to public_key.json'
    puts 'save private_key to private_key.json'
    File.write('public_key.json', { e: @e, n: @n }.to_json)
    File.write('private_key.json', { e: @e, d: @d }.to_json)
  end

  def calculate_n
    @n = @p * @q
  end

  def calculate_phi
    @phi = (@p - 1) * (@q - 1)
  end

  def calculate_d
    @d = 1
    loop do
      return @d if (@e * @d) % @phi == 1

      @d += 1
    end
  end
end

