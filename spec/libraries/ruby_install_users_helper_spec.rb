require "spec_helper"
require "./libraries/ruby_install_users_helper"

class RubyInstallProvider
  include RubyInstall::UsersHelper
end

describe RubyInstall::UsersHelper do
  let(:provider) { RubyInstallProvider.new }

  describe ".user_home_dir" do
    let :resource do
      r = Struct.new(:user)
      r.new("tom")
    end
    before { provider.new_resource = resource }
    subject { provider.user_home_dir }

    it do
      if /darwin/ =~ RUBY_PLATFORM
        expect(subject).to eq("/Users/tom")
      else
        expect(subject).to eq("/home/tom")
      end
    end
  end
end
