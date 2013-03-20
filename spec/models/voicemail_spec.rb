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

  describe "#mark_as_read" do
    it "sets read attribute to true and saves the record" do
      voicemail = Voicemail.create!
      voicemail.mark_as_read
      voicemail.read.should be_true
      voicemail.should be_persisted
    end
  end
end
