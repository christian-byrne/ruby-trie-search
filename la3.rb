# Author: Christian Byrne
# Course: CSc 372
# Date:   12/06/2024
# Desc:   A trie-based word search program that reads a file and allows the
#         user to search for words in it.

class Node
  # Represents a node in a trie structure.
  # @attr_accessor [Hash] children The child nodes of this node.
  # @attr_accessor [Boolean] is_terminal True if this node represents the end of a word.
  # @attr_reader [Object] data The data stored in this node, read-only.
  attr_accessor :children, :is_terminal
  attr_reader :data

  def initialize(data, is_terminal = false)
    @data = data
    @is_terminal = is_terminal
    @children = {}
  end
end

# Searches for a string in the trie, returning the last node and the matched prefix.
# @param root [Node] The root of the trie to search from.
# @param str [String] The string to search for.
# @param path [String] The prefix of the string matched so far (default: "").
# @return [Array<Node, String>] The last node and the matched prefix.
def search(root, str, path = "")
  return root, path unless root.children.key?(str[0])
  return root.children[str[0]], path + str[0] if str.length == 1
  search(root.children[str[0]], str[1..-1], path + str[0])
end

# Inserts a string into the trie.
# @param root [Node] The root of the trie to insert into.
# @param str [String] The string to insert.
def insert(root, str)
  cur, path = search(root, str)
  return if path == str
  str.delete_prefix(path).chars.each { |char| cur = cur.children[char] ||= Node.new(char) }
  cur.is_terminal = true
end

# Prints all paths from given root to leaves or nodes with is_terminal = true. Uses DFS.
# @param root [Node] The root of the trie to traverse.
# @param prefix [String] The prefix for the words to print.
def print_word_paths(root, prefix)
  return puts prefix if root.children.nil? || root.children.empty?
  puts prefix if root.is_terminal
  root.children.each { |key, node| print_word_paths(node, prefix + key) }
end

# Parses a file into a trie and builds a word location index.
# @param filename [String] The name of the file to parse.
# @return [Array<Node, Hash>] The root of the trie and a hash mapping words to their locations.
def parse_to_trie(filename)
  root, word_locs = Node.new(nil), {}
  File.foreach(filename).each_with_index do |line, line_index|
    line.split(/\s+/).each_with_index do |word, word_index|
      word_locs[word] = (word_locs[word] || []) + [[line_index, word_index]]
      insert(root, word)
    end
  end
  [root, word_locs]
end

print "Type the name of your file.\n> "
root, word_locs = parse_to_trie gets.chomp.strip
print "Type a string to search for.\n> "
while (query = gets.chomp) != ":q"
  if (start_node, path = search(root, query))[1] != query
    puts "Not found."
  else
    word_locs[query]&.each do |loc| puts "(#{loc[0]}, #{loc[1]})" end || print_word_paths(start_node, query)
  end
  print "> "
end
