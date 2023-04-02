# frozen_string_literal: true

require 'json'
require 'rubocop'
require_relative 'prime_number_generator'

class RSAKeyGenerator

  def self.call(...) = new(...).call

  attr_accessor :p, :q, :n, :phi, :e, :d, :length

  def initialize(len:, is_prime:)
    is_prime
    @length = len / 2
    @e = 65537
    prime_generator = PrimeNumberGenerator.new(length: length)
    @p = prime_generator.generate_new_prime
    generated = prime_generator.generate_new_prime
    @q = is_prime ? generated : generated + 1

  end

  def call
    calculate_n
    calculate_phi
    calculate_d
    puts 'save public_key to public_key.json'
    puts 'save private_key to private_key.json'
    File.write('public_key.json', { e: @e, n: @n }.to_json)
    File.write('private_key.json', { d: @d, n: @n }.to_json)
    @n
  end

  def calculate_n
    @n = @p * @q
  end

  def calculate_phi
    @phi = (@p - 1) * (@q - 1)
  end

  def calculate_d
    @d = mod_inverse(e, phi)
  end

end

private

def mod_inverse(a, m)
      g, x, y = gcd_extended(a, m)
      if g != 1
          puts "Inverse doesn't exist"
      else
          res = (x % m + m) % m
          puts "Modular multiplicative inverse is #{res}"
      end
      res
  end

  def gcd_extended(a, b)
      # Base Case
      if a == 0
          return b, 0, 1
      end

      # To store results of recursive call
      gcd, x1, y1 = gcd_extended(b % a, a)

      # Update x and y using results of recursive call
      x = y1 - (b / a) * x1
      y = x1

      return gcd, x, y
  end

