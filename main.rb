# frozen_string_literal: true

require 'rubocop'
require_relative 'rsa_key_generator'

def start(length)
  RSAKeyGenerator.call(length: length)
end

length = 128

start(length)
