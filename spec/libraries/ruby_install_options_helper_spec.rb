require "spec_helper"
require "./libraries/ruby_install_options_helper"

class RubyInstallProvider
  include RubyInstall::OptionsHelper
end

describe RubyInstall::OptionsHelper do
  let(:provider) { RubyInstallProvider.new }

  describe ".install_options" do
    subject { provider.install_options }

    it { expect(subject).to eq({}) }
  end

  describe ".register_user_option" do
    context "with existing option" do
      let :resource do
        r = Struct.new(:fo_o)
        r.new(:bar)
      end
      before { provider.new_resource = resource }

      it "should register options" do
        provider.register_user_option("fo_o")
        expect(provider.install_options).to eq({ "fo_o" => :bar })
      end
    end

    context "with non-existing option" do
      it "should not add option" do
        provider.register_user_option("baz")
        expect(provider.install_options).to eq({})
      end
    end
  end

  describe ".stringify_install_options" do
    subject { provider.stringify_install_options }

    context "option with value" do
      let :resource do
        r = Struct.new(:foo)
        r.new(:bar)
      end
      before do
        provider.new_resource = resource
        provider.register_user_option("foo")
      end

      it { expect(subject).to eq("--foo bar") }
    end

    context "option with true" do
      let :resource do
        r = Struct.new(:foo)
        r.new(true)
      end
      before do
        provider.new_resource = resource
        provider.register_user_option("foo")
      end

      it { expect(subject).to eq("--foo") }
    end

    context "option with false" do
      let :resource do
        r = Struct.new(:foo)
        r.new(false)
      end
      before do
        provider.new_resource = resource
        provider.register_user_option("foo")
      end

      it { expect(subject).to eq("") }
    end

    context "option without value" do
      let :resource do
        r = Struct.new(:foo)
        r.new("")
      end
      before do
        provider.new_resource = resource
        provider.register_user_option("foo")
      end

      it { expect(subject).to eq("--foo ") }
    end

    context "multiple options" do
      before do
        allow(provider).to receive_message_chain(:new_resource, "foo" => "bar")
        allow(provider).to receive_message_chain(:new_resource, "baz" => true)
        allow(provider).to receive_message_chain(:new_resource, "bat" => false)
        provider.register_user_option("foo")
        provider.register_user_option("baz")
        provider.register_user_option("bat")
      end

      it { expect(subject).to eq("--foo bar --baz") }
    end
  end

  describe ".ruby_string" do
    let :resource do
      r = Struct.new(:ruby)
      r.new("ruby 2.1.1")
    end
    before { provider.new_resource = resource }
    subject { provider.ruby_string }

    it "should remove spaces" do
      expect(subject).to eq("ruby-2.1.1")
    end
  end
end
