require 'spec_helper'

describe Voicemail do
  describe ".for_call_sid" do
    it "creates a voicemail instance with a given call sid" do
      vm = Voicemail.for_call_sid("foo")
      vm.should be_persisted
    end

    it "retrieves a voicemail record with a given call sid when it already exists" do
      existing = Voicemail.new.tap {|vm| vm.call_sid = "foo"; vm.save! }
      Voicemail.for_call_sid("foo").should == existing
    end
  end
end
