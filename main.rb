# frozen_string_literal: true

require 'rubocop'
require 'debug'
require 'json'
require 'gruff'
require 'prime_miller_rabin'
require_relative 'utils'
require_relative 'encoder'
require_relative 'decoder'
require_relative 'rsa_key_generator'
require_relative 'polard_attacker'
require_relative 'graph_creator'

Prime::MillerRabin.speed_intercept

class Time
  def to_ms
    (to_f * 1000.0).to_i
  end
end

ATTACK_TIME_BORDER = 60_000

def attack
  polard_stats = []
  border = 200
  flag = true
  (20..border).step(5) do |l|
    n = RSAKeyGenerator.call(len: l, is_prime: true)
    polard_stats << PolardAttacker.call(n: n)
    polard_stats.last.merge!({ l: l })
    puts({ time: polard_stats.last[:process_time], len: l })
    if polard_stats.last[:process_time] >= ATTACK_TIME_BORDER
      @len = l + 1
      break
    end
  end
  (@len..@len + 4).step(1) do |l|
    n = RSAKeyGenerator.call(len: l, is_prime: true)
    polard_stats << PolardAttacker.call(n: n)
    polard_stats.last.merge!({ l: l })
    puts({ time: polard_stats.last[:process_time], len: l })
  end
  lengthes = polard_stats.map { |el| el[:l].to_s }
  data = polard_stats.map { |el| el[:process_time] }
  GraphCreator.call(label_data: lengthes, data: data, output: 'attack_results.png')
  File.write('polard_stats_with_l.json', JSON.pretty_generate(polard_stats))
end

def analyze_largest_length
  l = JSON.parse(File.read('polard_stats_with_l.json')).last['l'].to_i
  polard_stats = []
  (0.25..0.5).step(0.025) do |r|
    p_len = (r * l).to_i
    q_len = ((1 - r) * l).to_i
    p = PrimeNumberGenerator.new(length: p_len).generate_new_prime
    q = PrimeNumberGenerator.new(length: q_len).generate_new_prime
    n = p * q
    polard_stats << PolardAttacker.call(n: n)
    polard_stats.last.merge!({ r: r })
    puts({ time: polard_stats.last[:process_time], r: r, l: l })
  end
  data = polard_stats.map { |el| el[:process_time] }
  lengthes = polard_stats.map { |el| el[:r].round(3).to_s }
  GraphCreator.call(label_data: lengthes, data: data, output: 'analyzed_largest_length.png')
  File.write('polard_stats_with_r.json', JSON.pretty_generate(polard_stats))
end

def start(length, plain, is_prime)
  RSAKeyGenerator.call(len: length, is_prime: is_prime)

  encrypted = "encrypted-#{plain}"
  decrypted = "decrypted-#{plain}"

  Encoder.call(len: length, plain: plain, encrypted: encrypted)
  Decoder.call(encrypted: encrypted, decrypted: decrypted)
end

length = 70
plain = 'dog.jpeg'
is_prime = true

case ARGV[0]
when '--generate_keys'
  generate_keys
when '--attack'
  attack
when '--analyze'
  analyze_largest_length
else
  start(length, plain, is_prime)
end
