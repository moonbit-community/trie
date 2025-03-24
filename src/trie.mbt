///|
struct T[A] {
  value : A?
  forks : @immut/sorted_map.T[Char, T[A]]
}

///|
pub fn lookup[A](self : T[A], path : String) -> A? {
  loop path.view(), self {
    [], trie => trie.value
    [x, .. xs], trie =>
      match trie.forks[x] {
        None => None
        Some(subtree) => continue xs, subtree
      }
  }
}

///| 
#deprecated("use `add` instead")
pub fn insert[A](self : T[A], path : String, value : A) -> T[A] {
  self.add(path, value)
}

///|
pub fn add[A](self : T[A], path : String, value : A) -> T[A] {
  fn aux {
    ([] : @string.View), trie => T::{ ..trie, value: Some(value) }
    [x, .. xs], trie => {
      let subtree = trie.forks[x].or({
        value: None,
        forks: @immut/sorted_map.new(),
      })
      { ..trie, forks: trie.forks.add(x, aux(xs, subtree)) }
    }
  }

  aux(path.view(), self)
}

///|
pub fn empty[a]() -> T[a] {
  T::{ value: None, forks: @immut/sorted_map.new() }
}

///|
pub fn T::of[A](data : FixedArray[(String, A)]) -> T[A] {
  loop 0, empty() {
    i, trie =>
      if i == data.length() {
        trie
      } else {
        let (s, v) = data[i]
        continue i + 1, trie.add(s, v)
      }
  }
}

///|
pub fn T::from_array[A](data : Array[(String, A)]) -> T[A] {
  loop 0, empty() {
    i, trie =>
      if i == data.length() {
        trie
      } else {
        let (s, v) = data[i]
        continue i + 1, trie.add(s, v)
      }
  }
}
