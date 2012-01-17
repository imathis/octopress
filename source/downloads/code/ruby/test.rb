class Float
  def number_decimal_places
    self.to_s.length-2
  end
  def to_fraction
    higher = 10**self.number_decimal_places
    lower = self*higher
    gcden = greatest_common_divisor(higher, lower)

    return (lower/gcden).round, (higher/gcden).round
  end

private
  def greatest_common_divisor(a, b)
     while a%b != 0
       a,b = b.round,(a%b).round
     end
     return b
  end
end
