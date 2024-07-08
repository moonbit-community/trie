struct Trie[A] {
  value : A?
  forks : @immut/sorted_map.Map[Char, Trie[A]]
}

pub fn lookup[A](self : Trie[A], path : String) -> A? {
  loop path.to_array()[..], self {
    [], trie => trie.value
    [x, .. as xs], trie =>
      match trie.forks[x] {
        None => None
        Some(subtree) => continue xs, subtree
      }
  }
}

pub fn insert[A](self : Trie[A], path : String, value : A) -> Trie[A] {
  fn aux {
    ([] : ArrayView[Char]), trie => Trie::{ ..trie, value: Some(value) }
    [x, .. as xs], trie => {
      let subtree = trie.forks[x].or(
        { value: None, forks: @immut/sorted_map.empty() },
      )
      { ..trie, forks: trie.forks.insert(x, aux(xs, subtree)) }
    }
  }

  aux(path.to_array()[..], self)
}

pub fn empty[a]() -> Trie[a] {
  Trie::{ value: None, forks: @immut/sorted_map.empty() }
}

pub fn Trie::from_array[a](data : Array[(String, a)]) -> Trie[a] {
  loop 0, empty() {
    i, trie =>
      if i == data.length() {
        trie
      } else {
        let (s, v) = data[i]
        continue i + 1, trie.insert(s, v)
      }
  }
}

test {
  let trie = Trie::[("--search", "search"), ("-s", "s"), ("--switch", "switch")]
  @test.eq(trie.lookup("--search"), Some("search"))!
  @test.eq(trie.lookup("-s"), Some("s"))!
  @test.eq(trie.lookup("--switch"), Some("switch"))!
}
