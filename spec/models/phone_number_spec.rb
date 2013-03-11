require 'spec_helper'

describe PhoneNumber do
  it "can import phone numbers from Twilio" do
    TwilioWrapper.instance.should_receive(:incoming_phone_numbers).and_return(["one", "two"])
    PhoneNumber.import_numbers
    PhoneNumber.count.should == 2
    PhoneNumber.first.incoming_number.should == "one"
  end

  it "defaults forwarding to false" do
    PhoneNumber.new.forwarding? == false
  end

  describe PhoneNumber::NullPhoneNumber do
    it "can be instantiated with an incoming number" do
      null_phone_number = PhoneNumber::NullPhoneNumber.new(incoming_number: "foobarbaz")
      null_phone_number.incoming_number.should == "foobarbaz"
    end
  end
end
