class Encoder
  def self.call(...) = new(...).call

  def initialize(len:, plain:, encrypted:)
    @length = len / 4
    @plain_bytes = Utils::read_bin_file(plain)
    @e, @n = JSON.parse(File.read('public_key.json')).values
    @encrypted = encrypted
  end

  def call
    puts 'start encoding'
    encoded = plain_bytes.map do |m|
                  encrypt_rsa(m)
                end
    puts 'encoding OK'
    File.write(encrypted, encoded)
  end

  private

  attr_reader :length, :plain_text, :e, :n, :plain_in_bits, :plain_bytes, :encrypted

  def encrypt_rsa(m)
    Utils::fast_power_mod(m, e, n)
  end
end
