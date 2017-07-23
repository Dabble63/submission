# WORD FINDER

To run the code use: ./server.pl daemon --listen http://0.0.0.0:80

This will start the web server, listening on port 80 from all addresses.

To run the unit tests: ./server.pl test



Finding all of the possible words involves generating words to test and testing them against a word list.
In order to reduce the number of tests, we use a Trie to determine whether a set of letters constitutes the prefix of any words.
This keeps the number of tests to a minimal number and allows good performance. The Trie is created on startup.


## The main wordfinder routine (test).

At any given level, we test whether adding one letter to the current prefix creates a word or a prefix of a valid word. The Trie will return the word if it is a valid word, or a random word if it is the prefix of other words. If the prefix is valid, the routine is called recursively with the longer prefix and a smaller list of unused letters.

If there are duplicate letters only the first needs to be tested at this level. This prevents duplicate words from being found.

### Input:

- prefix
The letters already used which are the prefix of one or more words.
- unused
The letters not already used to make the prefixa. The letters must be sorted.

### Output:

A list of the words which can be formed with the given prefix and letters.

