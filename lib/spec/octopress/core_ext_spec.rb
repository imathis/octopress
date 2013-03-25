require 'minitest/autorun'
require_relative '../../octopress'

describe Hash do
  # Using functions here because it's easy to ensure we get fresh instances all
  # the way down the hierarchy this way -- and we can produce both input, and
  # expected output data cleanly while ensuring they stay in sync.
  def create_complex_array(mode)
    case mode
    when :mixed
      keys = ['a_string_sub_hash_key', :a_symbol_sub_hash_with]
    when :symbols
      keys = [:a_string_sub_hash_key, :a_symbol_sub_hash_with]
    when :strings
      keys = ['a_string_sub_hash_key', 'a_symbol_sub_hash_with']
    end

    array = [
      # Some miscellaneous types just to ensure we don't choke on random things...
      nil,
      false,
      true,
      1,
      {
        keys[0] => 1,
        keys[1] => 1,
      },
    ]
  end

  def create_complex_hash(mode)
    case mode
    when :mixed
      keys = [
        "a_string_hash_key",
        :a_symbol_hash_key,
        "another_string_hash_key",
        :another_symbol_hash_key,
      ]
    when :symbols
      keys = [
        :a_string_hash_key,
        :a_symbol_hash_key,
        :another_string_hash_key,
        :another_symbol_hash_key,
      ]
    when :strings
      keys = [
        "a_string_hash_key",
        "a_symbol_hash_key",
        "another_string_hash_key",
        "another_symbol_hash_key",
      ]
    end

    hash = {
      keys[0] => {
        keys[0] => 1,
        keys[1] => 1,
        keys[2] => create_complex_array(mode),
        keys[3] => create_complex_array(mode),
      },
      keys[1] => {
        keys[0] => 1,
        keys[1] => 1,
        keys[2] => create_complex_array(mode),
        keys[3] => create_complex_array(mode),
      },
      keys[2] => create_complex_array(mode),
      keys[3] => create_complex_array(mode),
    }

    return hash
  end

  describe '#to_symbol_keys' do
    subject do
      # Cover all sorts of permutations of structure here...
      create_complex_hash(:mixed).to_symbol_keys
    end

    it "recursively converts hash keys into symbols" do
      subject.must_equal create_complex_hash(:symbols)
    end
  end

  describe '#to_string_keys' do
    subject do
      # Cover all sorts of permutations of structure here...
      create_complex_hash(:mixed).to_string_keys
    end

    it "recursively converts hash keys into strings" do
      subject.must_equal create_complex_hash(:strings)
    end
  end
end
