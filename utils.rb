# frozen_string_literal: true

class Utils
  def self.read_bin_file(plain)
    bytes = []
    File.open(plain, 'rb') do |file|
      bytes = file.read.bytes
    end
    bytes
  end

  def self.byte_array_to_bit_array(bytes)
    bytes.map { |byte| byte.to_s(2).rjust(8, '0') }.join('').split('').map(&:to_i)
  end

  def self.bit_array_to_byte_array(bits)
    bytes = []
    bits.each_slice(8) do |slice|
      n = slice.inject(0) { |sum, bit| (sum << 1) + bit }
      bytes << n
    end
    bytes
  end

  def self.fast_power_mod(x, d, n)
    y = 1
    while d.positive?
      y = (y * x) % n if d.odd?
      d /= 2
      x = (x * x) % n
    end
    y
  end

  def self.read_file_as_bits(file_name, length)
    bits = []
    File.open(file_name, 'rb') do |file|
      while (bytes = file.read(length))
        bytes.each_byte do |byte|
          8.times do |i|
            bits << ((byte >> i) & 1)
          end
        end
      end
    end
    bits
  end

  def self.split_bits(bits, length)
    subarrays = bits.each_slice(length).to_a
    last_subarray = subarrays.last
    last_subarray.concat([0] * (length - last_subarray.length)) if last_subarray.length < length
    subarrays
  end
end
