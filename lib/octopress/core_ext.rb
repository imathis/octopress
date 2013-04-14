require 'jekyll/core_ext'

module Octopress
  # Helper functions we want when working with Hash structures.
  module HashHelpers
    # Static.  A utility function to recursively transform all keys in a
    # structure according to the provided function.  Will dive into Hash and
    # Array elements to perform the replacement.  Will not dive into other
    # constructs such as OpenStruct, or arbitrary classes.
    #
    # This is non-destructive:  The produced structure will be a copy of the
    # structure passed in, however all values in Hash and Array objects will be
    # references to objects in the original structure.
    #
    # entity - The structure to analyze.  May be anything, but it's really only
    # useful if this is an Array or Hash, as otherwise this will be a no-op.
    # block  - The transformation function to perform on all hash keys.  If
    # this function produces duplicate keys for a given hash, it is undefined
    # as to which one will 'win'.
    #
    # Returns a structure whose type is identical to that of `entity`, such
    # that any Hash elements throughout the depth of the structure have had
    # their keys transformed via `block`.
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
  # Returns a new Hash, whose keys have recursively been coerced into symbols.
  def to_symbol_keys
    Octopress::HashHelpers.transform_keys_recursively(self, &:to_sym)
  end

  # Returns a new Hash, whose keys have recursively been coerced into strings.
  def to_string_keys
    Octopress::HashHelpers.transform_keys_recursively(self, &:to_s)
  end
end
