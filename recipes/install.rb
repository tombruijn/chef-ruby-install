include_recipe "ruby-install::default"

attributes = node["ruby-install"]
rubies = attributes["rubies"]

rubies.each do |config|
  ruby_install_ruby config["ruby"] do
    ruby config["ruby"]
    install_dir config["install-dir"]
    user config["user"]
    group config["group"]
    gems config["gems"]
    md5 config["md5"]
    sha1 config["sha1"]
    sha256 config["sha256"]
    sha512 config["sha512"]

    if config["reinstall"]
      action :reinstall
    else
      action :install
    end
  end
end
