class Hash
  # Merges self with another hash, recursively.
  #
  # This code was lovingly stolen from some random gem:
  # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
  #
  # Thanks to whoever made it.
  def deep_merge(hash)
    target = dup
    hash.keys.each do |key|
      if hash[key].is_a? Hash and self[key].is_a? Hash
        target[key] = target[key].deep_merge(hash[key])
        next
      end
      target[key] = hash[key]
    end

    target
  end
  def to_symbol_keys
    inject({}) { |memo,(k,v)| memo[k.to_sym] = v; memo }
  end
  def to_string_keys
    inject({}) { |memo,(k,v)| memo[k.to_s] = v; memo }
  end
end
