///|
struct T[A] {
  value : A?
  forks : @immut/sorted_map.T[Char, T[A]]
}

///|
pub fn[A] lookup(self : T[A], path : String) -> A? {
  loop (path.view(), self) {
    ([], trie) => trie.value
    ([x, .. xs], trie) =>
      match trie.forks.get(x) {
        None => None
        Some(subtree) => continue (xs, subtree)
      }
  }
}

///|
#deprecated("use `add` instead")
pub fn[A] insert(self : T[A], path : String, value : A) -> T[A] {
  self.add(path, value)
}

///|
pub fn[A] add(self : T[A], path : String, value : A) -> T[A] {
  fn aux(path : @string.View, trie) {
    match path {
      [] => T::{ ..trie, value: Some(value) }
      [x, .. xs] => {
        let subtree = trie.forks
          .get(x)
          .unwrap_or({ value: None, forks: @immut/sorted_map.new() })
        { ..trie, forks: trie.forks.add(x, aux(xs, subtree)) }
      }
    }
  }

  aux(path.view(), self)
}

///|
pub fn[a] empty() -> T[a] {
  T::{ value: None, forks: @immut/sorted_map.new() }
}

///|
pub fn[A] of(data : FixedArray[(String, A)]) -> T[A] {
  loop (0, empty()) {
    (i, trie) =>
      if i == data.length() {
        trie
      } else {
        let (s, v) = data[i]
        continue (i + 1, trie.add(s, v))
      }
  }
}

///|
pub fn[A] T::from_array(data : Array[(String, A)]) -> T[A] {
  loop (0, empty()) {
    (i, trie) =>
      if i == data.length() {
        trie
      } else {
        let (s, v) = data[i]
        continue (i + 1, trie.add(s, v))
      }
  }
}
