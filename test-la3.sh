#!/bin/bash

# Won't work if you used BFS instead of DFS, or didn't match the output format from spec

run_test() {
  local test_name=$1
  local input=$2
  local expected_output=$3

  echo -e "\n\033[1;34mRunning test: $test_name\033[0m"

  # Run the program and capture output
  local output=$(echo "$input" | ruby la3.rb)

  if [ "$output" == "$expected_output" ]; then
    echo -e "\033[1;32mTest passed!\033[0m"
  else
    echo -e "\033[1;31mTest failed!\033[0m"
    echo -e "\033[1;33mExpected:\033[0m"
    echo "$expected_output"
    echo -e "\033[1;33mGot:\033[0m"
    echo "$output"
  fi
}

# Test case 1
run_test "Testing inputs from spec" \
"simple.txt
susan
sue
sea
seas
seashore
:q" \
"Type the name of your file.
> Type a string to search for.
> Not found.
> (0, 0)
> (4, 2)
> seashells
seashore
> (2, 2)
(3, 2)
> "

# Test case 2
run_test "Should print full words that are also prefixes" \
"wl.txt
kno
:q" \
"Type the name of your file.
> Type a string to search for.
> know
known
knock
> "

# Test case 3
run_test "Should print location when query is fullword" \
"wl.txt
shadow
Meer.
shantih
:q" \
"Type the name of your file.
> Type a string to search for.
> (30, 2)
(31, 4)
(33, 1)
(34, 2)
> (49, 4)
> (487, 2)
(487, 3)
> "

# Test case 4
run_test "Should print location only when query is fullword and prefix" \
"wl.txt
know
:q" \
"Type the name of your file.
> Type a string to search for.
> (26, 7)
(128, 2)
(138, 1)
(163, 3)
(171, 2)
(413, 3)
> "

# Test case 5
run_test "Should print locations/matches of words with punctuation" \
"ruby.txt
Don't
Don
Ruby!
Ru
:q" \
"Type the name of your file.
> Type a string to search for.
> (3, 1)
> Don't
> (0, 1)
> Ruby!
Ruby,
> "

# Test case 6
run_test "Should return all words on empty query / Should not print repeats" \
"simple.txt

:q" \
"Type the name of your file.
> Type a string to search for.
> sue
sells
seashells
seashore
on
the
at
by
> "

# Test case 7
run_test "Should correctly parse first word in file" \
"simple.txt
sue
:q" \
"Type the name of your file.
> Type a string to search for.
> (0, 0)
> "

# Test case 8
run_test "Should correctly parse last word in file" \
"poem.txt
explod
explode?
:q" \
"Type the name of your file.
> Type a string to search for.
> explode?
> (15, 4)
> "
