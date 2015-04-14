name "ruby-install"
maintainer "Tom de Bruijn"
maintainer_email "tom@tomdebruijn.com"
license "MIT"
description "Installs postmodern's ruby-install and optionally Ruby versions."
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version "0.2.0"

%w(debian ubuntu centos mac_os_x).each do |os|
  supports os
end

depends "git"
