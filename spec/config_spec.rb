require 'spec_helper'

describe KitchenBoy::Config do
  subject { KitchenBoy::Config.instance }

  describe ".bootstrap_home_dir" do
    context "when passing a valid home_dir" do
      it { expect(subject.bootstrap_home_dir).to be(true) }
      it { expect(Dir).to exist($home_dir) }
    end
    context "when passing an invalid home_dir" do
      before { subject.home_dir = '/invalid_home_dir' }
      it { expect(subject.bootstrap_home_dir).to be(false) }
    end
  end
end
