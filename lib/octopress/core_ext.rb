module Octopress
  module HashHelpers
    def self.transform_keys_recursively(entity, &block)
      result = entity
      case entity
      when Hash
        result = Hash[entity.map do |key, value|
          [block.call(key), self.transform_keys_recursively(value, &block)]
        end]
      when Array
        result = entity.map { |elem| self.transform_keys_recursively(elem, &block) }
      end
      return result
    end
  end
end

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
    Octopress::HashHelpers.transform_keys_recursively(self, &:to_sym)
  end

  def to_string_keys
    Octopress::HashHelpers.transform_keys_recursively(self, &:to_s)
  end
end
