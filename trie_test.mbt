///|
test {
  let trie = @trie.T::of([
    ("--search", "search"),
    ("-s", "s"),
    ("--switch", "switch"),
  ])
  @debug.assert_eq(trie.lookup("--search"), Some("search"))
  @debug.assert_eq(trie.lookup("-s"), Some("s"))
  @debug.assert_eq(trie.lookup("--switch"), Some("switch"))
}
