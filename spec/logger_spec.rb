require 'spec_helper'

class Dummy
  extend KitchenBoy::Logger
end

describe KitchenBoy::Logger do
  let(:message) { 'Testing output!' }

  describe "#log_success" do
    subject do
      @output = capture_stdout do
        Dummy.log_success(message)
      end
    end
    it { should include(message) }
  end

  describe "#log_warning" do
    subject do
      @output = capture_stdout do
        Dummy.log_warning(message)
      end
    end
    it { should include(message) }
  end

  describe "#log_error" do
    subject do
      @output = capture_stderr do
        Dummy.log_error(message)
      end
    end
    it { should include(message) }
  end
end
