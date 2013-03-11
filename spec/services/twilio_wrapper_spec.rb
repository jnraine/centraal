require 'spec_helper'

describe TwilioWrapper do
  describe "#incoming_phone_numbers" do
    it "returns incoming numbers registered with this app on Twilio" do
      actual = TwilioWrapper.instance.incoming_phone_numbers
      actual.should == ["+16042004455"]
    end
  end

  describe "#instance" do
    TwilioWrapper.instance.object_id.should == TwilioWrapper.instance.object_id
  end
end