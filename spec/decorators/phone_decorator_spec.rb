require 'spec_helper'

describe PhoneDecorator do
  let(:messages) do
    {
      voicemail: false,
      forwarding: false
    }
  end

  let(:phone) { mock(:phone, messages) }
  let(:decorator) { PhoneDecorator.new(phone) }

  describe "#prettify_number" do
    it "takes an E.164 formatter phone number and makes it pretty" do
      decorator.prettify_number("+16045551234").should == "+1 (604) 555-1234"
    end

    it "returns an empty string when number is nil" do
      decorator.prettify_number(nil).should == ""
    end
  end

  describe "#voicemail" do
    it "returns a word to describe the state of the voicemail" do
      decorator.model.stub(:voicemail).and_return(true)
      decorator.voicemail.should == "On"
      decorator.model.stub(:voicemail).and_return(false)
      decorator.voicemail.should == "Off"
    end
  end
end
