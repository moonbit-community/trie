struct Trie[a] {
  value : a?
  forks : @immut/sorted_map.Map[Char, Trie[a]]
}

pub fn lookup[a](self : Trie[a], path : String) -> a? {
  let xs = string_to_list(path)
  loop xs, self {
    List::Nil, trie => trie.value
    Cons(x, xs), trie =>
      match trie.forks.lookup(x) {
        None => None
        Some(subtree) => continue xs, subtree
      }
  }
}

pub fn insert[a](self : Trie[a], path : String, value : a) -> Trie[a] {
  let xs = string_to_list(path)
  fn aux {
    List::Nil, trie => Trie::{ ..trie, value: Some(value) }
    Cons(x, xs), trie => {
      let subtree = trie.forks.lookup(x).or(
        { value: None, forks: @immut/sorted_map.empty() },
      )
      { ..trie, forks: trie.forks.insert(x, aux(xs, subtree)) }
    }
  }

  aux(xs, self)
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

fn string_to_list(s : String) -> List[Char] {
  loop 0, List::Nil {
    i, ls => if i == s.length() { ls } else { continue i + 1, Cons(s[i], ls) }
  }
}

test {
  let trie = Trie::[("--search", "search"), ("-s", "s"), ("--switch", "switch")]
  @assertion.assert_eq(trie.lookup("--search"), Some("search"))?
  @assertion.assert_eq(trie.lookup("-s"), Some("s"))?
  @assertion.assert_eq(trie.lookup("--switch"), Some("switch"))?
}
