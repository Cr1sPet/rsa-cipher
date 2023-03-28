# frozen_string_literal: true

require 'rubocop'
require 'debug'
require 'json'
require 'prime_miller_rabin'
require_relative 'utils'
require_relative 'encoder'
require_relative 'decoder'
require_relative 'rsa_key_generator'

Prime::MillerRabin.speed_intercept

def start(length, plain)
  RSAKeyGenerator.call(len: length)

  encrypted = "encrypted-#{plain}"
  decrypted = "decrypted-#{plain}"

  Encoder.call(len: length, plain: plain, encrypted: encrypted)
  Decoder.call(encrypted: encrypted, decrypted: decrypted)
end

length = 128
plain = 'dog.jpeg'

start(length, plain)
