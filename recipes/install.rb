include_recipe "ruby-install::default"

attributes = node["ruby-install"]
rubies = attributes["rubies"]

rubies.each do |config|
  ruby_install_ruby config["ruby"] do
    ruby config["ruby"]
    rubies_path attributes["rubies_path"]
    update_path config["update_path"]
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
