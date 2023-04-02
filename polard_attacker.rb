# frozen_string_literal: true

class PolardAttacker

  def self.call(...) = new(...).call

  def initialize(n:)
    @n = n
  end

  def call
    start_time = Time.now
    p = pollard_attack
    q = n / p
    end_time = Time.now
    {start_time: start_time,
    end_time: end_time,
    process_time: end_time.to_ms - start_time.to_ms,
    p: p,
    q: q,
    n: n}
  end


  private

    attr_reader :n, :l

    def gcd(a, b)
      while b != 0
        t = a % b
        a = b
        b = t
      end
      a
    end


    def pollard_attack
      x0 = rand(1..n - 2)
      k = 1
      gcd = 0
      (1...n).each do
        x = [x0]
        z = 1
        ((2**k) + 1..2**(k + 1) + 1).each do
          x << ((x[z - 1]**2) + 1) % n
          gcd = gcd(n, (x[0] - x[z]).abs)
          return gcd if gcd > 1

          z += 1
        end
        x0 = x[z - 1]
        k += 1
        x = nil
      end
    end
end
