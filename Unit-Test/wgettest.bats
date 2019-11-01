@test "that wget connects to API" {
  wget https://hypothes.is/api/search?url=https://plato.stanford.edu/entries/self-consciousness/
  [ -f "search?url=https:%2F%2Fplato.stanford.edu%2Fentries%2Fself-consciousness%2F" ]
}
