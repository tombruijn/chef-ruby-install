@test "ruby-install binary is found in PATH" {
  run which ruby-install
  [ "$status" -eq 0 ]
}

@test "ruby-install version" {
  run ruby-install --version
  [ "$output" = "ruby-install: 0.4.3" ]
}
