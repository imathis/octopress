require 'jekyll/core_ext'

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
  def to_symbol_keys
    Octopress::HashHelpers.transform_keys_recursively(self, &:to_sym)
  end

  def to_string_keys
    Octopress::HashHelpers.transform_keys_recursively(self, &:to_s)
  end
end
