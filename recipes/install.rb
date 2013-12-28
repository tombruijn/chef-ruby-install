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

    if config["reinstall"]
      action :reinstall
    else
      action :install
    end
  end
end
