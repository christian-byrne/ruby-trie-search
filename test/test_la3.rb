require 'test/unit'
require_relative 'la3'

class TestTrie < Test::Unit::TestCase
  def setup
    @root, @word_locs = parse_to_trie("simple.txt")
  end

  def test_search_not_found
    assert_false search(@root, "susan"), "Expected 'susan' not to be found"
  end

  def test_search_found
    start_node = search(@root, "sue")
    assert_not_nil start_node, "Expected 'sue' to be found"
    assert_equal [[0, 0]], @word_locs["sue"]
  end

  def test_prefix_with_locations
    start_node = search(@root, "sea")
    assert_not_nil start_node, "Expected 'sea' to be found"
    assert_equal [[4, 2]], @word_locs["sea"]
  end

  def test_prefix_with_leaves
    start_node = search(@root, "seas")
    assert_not_nil start_node, "Expected 'seas' to be found"
    leaves = get_leaves(start_node, "seas")
    assert_equal ["seashells", "seashore"], leaves
  end

  def test_multiple_locations
    start_node = search(@root, "seashore")
    assert_not_nil start_node, "Expected 'seashore' to be found"
    assert_equal [[2, 2], [3, 2]], @word_locs["seashore"]
  end
end
