struct T[A] {
  value : A?
  forks : @immut/sorted_map.T[Char, T[A]]
}

pub fn lookup[A](self : T[A], path : String) -> A? {
  loop path.to_array()[:], self {
    [], trie => trie.value
    [x, .. as xs], trie =>
      match trie.forks[x] {
        None => None
        Some(subtree) => continue xs, subtree
      }
  }
}

pub fn insert[A](self : T[A], path : String, value : A) -> T[A] {
  fn aux {
    ([] : ArrayView[Char]), trie => T::{ ..trie, value: Some(value) }
    [x, .. as xs], trie => {
      let subtree = trie.forks[x].or(
        { value: None, forks: @immut/sorted_map.empty() },
      )
      { ..trie, forks: trie.forks.insert(x, aux(xs, subtree)) }
    }
  }

  aux(path.to_array()[:], self)
}

pub fn empty[a]() -> T[a] {
  T::{ value: None, forks: @immut/sorted_map.empty() }
}

pub fn T::of[A](data : FixedArray[(String,A)]) -> T[A] {
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

pub fn T::from_array[A](data : Array[(String, A)]) -> T[A] {
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

