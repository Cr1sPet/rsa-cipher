class Decoder
  def self.call(...) = new(...).call

  def initialize(encrypted:, decrypted:)
    @encrypted_bytes = eval(File.read(encrypted))
    @d, @n = JSON.parse(File.read('private_key.json')).values
    @decrypted = decrypted
  end

  def call
    puts 'start decoding'
    decoded = encrypted_bytes.map do |c|
                  decrypt_rsa(c)
              end
    puts 'decoding OK'
    File.open(decrypted, "wb") do |file|
      file.write(decoded.pack("C*"))
    end
  end

  private

  attr_reader :length, :plain_text, :e, :d, :n, :plain_in_bits, :plain_in_bytes, :encrypted_bytes, :decrypted, :ms

  def decrypt_rsa(c)
    Utils::fast_power_mod(c, d, n)
  end

end
