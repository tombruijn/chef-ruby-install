@test "specified ruby installed" {
  run /opt/rubies/ruby-2.0.0-p353/bin/ruby -v
  echo $output | grep "ruby 2.0.0p353" 1>/dev/null 2>&1
}

@test "bundler gem installed" {
  # Change the gem path, to overwrite busser's path changes.
  export GEM_HOME="/opt/rubies/ruby-2.0.0-p353/lib/ruby/gems/2.0.0";
  export GEM_PATH="/opt/rubies/ruby-2.0.0-p353/lib/ruby/gems/2.0.0";
  export GEM_CACHE="/opt/rubies/ruby-2.0.0-p353/lib/ruby/gems/2.0.0/cache";

  run /opt/rubies/ruby-2.0.0-p353/bin/gem list
  echo $output | grep "bundler" 1>/dev/null 2>&1
}
