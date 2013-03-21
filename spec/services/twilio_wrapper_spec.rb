require 'spec_helper'

describe TwilioWrapper do

  describe "#incoming_phone_numbers" do
    # it "returns incoming numbers registered with this app on Twilio" do
    #   # pending "Needs API to be live"
    #   actual = TwilioWrapper.instance.incoming_phone_numbers
    #   actual.should == ["+16042004455"]
    # end
  end

  describe "#instance" do
    TwilioWrapper.instance.object_id.should == TwilioWrapper.instance.object_id
  end

  describe "#setting" do
    it "pulls a setting name from ENV" do
      ENV["TWILIO_FOO"] = "some value"
      TwilioWrapper.instance.setting("foo").should == "some value"
    end
  end

  describe "#setting_set" do
    it "sets an environment variable for twilio" do
      TwilioWrapper.instance.setting_set("foo", "just set")
      ENV["TWILIO_FOO"].should == "just set"
    end
  end
end
