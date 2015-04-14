actions :install, :reinstall
default_action :install

attribute :ruby, kind_of: String, name_attribute: true
attribute :gems, kind_of: Array
attribute :user, kind_of: String
attribute :group, kind_of: String
attribute :environment, kind_of: Hash

attribute :src_dir, kind_of: String
attribute :install_dir, kind_of: String
attribute :patch, kind_of: String
attribute :mirror, kind_of: String
attribute :url, kind_of: String
attribute :md5, kind_of: String
attribute :sha1, kind_of: String
attribute :sha256, kind_of: String
attribute :sha512, kind_of: String
attribute :no_download, kind_of: [TrueClass, FalseClass], default: false
attribute :no_verify, kind_of: [TrueClass, FalseClass], default: false
attribute :no_install_deps, kind_of: [TrueClass, FalseClass], default: false
attribute :no_reinstall, kind_of: [TrueClass, FalseClass], default: false
