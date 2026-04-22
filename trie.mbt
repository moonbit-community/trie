///|
#alias(T)
struct Trie[A] {
  value : A?
  forks : @immut/sorted_map.SortedMap[Char, Trie[A]]
}

///|
pub fn[A] Trie::lookup(self : Self[A], path : String) -> A? {
  for xs = path.view(), trie = self {
    match xs {
      [] => break trie.value
      [x, .. xs] =>
      match trie.forks.get(x) {
        None => break None
        Some(subtree) => continue xs, subtree
      }
    }
  }
}

///|
#deprecated("use `add` instead")
pub fn[A] Trie::insert(self : Self[A], path : String, value : A) -> Trie[A] {
  self.add(path, value)
}

///|
pub fn[A] Trie::add(self : Self[A], path : String, value : A) -> Trie[A] {
  fn aux(xs, trie) {
    match xs {
      ([] : StringView) => Trie::{ ..trie, value: Some(value) }
      [x, .. xs] => {
        let subtree = trie.forks
          .get(x)
          .unwrap_or_else(() => { value: None, forks: @immut/sorted_map.new() })
        { ..trie, forks: trie.forks.add(x, aux(xs, subtree)) }
      }
    }
  }

  aux(path.view(), self)
}

///|
#deprecated("Use Trie::empty instead")
pub fn[A] empty() -> Trie[A] {
  Trie::{ value: None, forks: @immut/sorted_map.new() }
}

///|
pub fn[A] Trie::empty() -> Trie[A] {
  Trie::{ value: None, forks: @immut/sorted_map.new() }
}

///|
/// Create a trie from `FixedArray`
pub fn[A] Trie::of(data : FixedArray[(String, A)]) -> Trie[A] {
  for i = 0, trie = Trie::empty() {
    if i == data.length() {
      break trie
    } else {
      let (s, v) = data[i]
      continue i + 1, trie.add(s, v)
    }
  }
}

///|
/// Create a trie from array.
pub fn[A] Trie::from_array(data : Array[(String, A)]) -> Trie[A] {
  for i = 0, trie = Trie::empty() {
    if i == data.length() {
      break trie
    } else {
      let (s, v) = data[i]
      continue i + 1, trie.add(s, v)
    }
  }
}
