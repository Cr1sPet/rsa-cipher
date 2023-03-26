# frozen_string_literal: true

require 'rubocop'
require 'prime_miller_rabin'
require_relative 'rsa_key_generator'

Prime::MillerRabin.speed_intercept
def start(length)
  RSAKeyGenerator.call(length: length)
end

length = 64

start(length)
