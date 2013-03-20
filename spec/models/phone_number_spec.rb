require 'spec_helper'

describe PhoneNumber do
  describe ".sync_numbers" do
    let(:bobs_office) { "+15551234567" }
    let(:amys_office) { "+15557654321" }

    it "can sync missing phone numbers from Twilio" do
      TwilioWrapper.instance.should_receive(:incoming_phone_numbers).and_return([bobs_office, amys_office])
      PhoneNumber.sync_numbers
      PhoneNumber.count.should == 2
      PhoneNumber.all.map(&:incoming_number).should == [bobs_office, amys_office]
    end

    it "creates records only for numbers that don't already exist" do
      TwilioWrapper.instance.should_receive(:incoming_phone_numbers).and_return([bobs_office, amys_office])
      existing_number = PhoneNumber.new.tap {|p| p.incoming_number = bobs_office; p.save! }
      PhoneNumber.sync_numbers
      PhoneNumber.where(:incoming_number => bobs_office).count.should == 1
    end
  end

  it "defaults forwarding to false" do
    PhoneNumber.new.forwarding? == false
  end

  describe ".valid_number?" do
    it "returns true when a number is in E.164 format" do
      PhoneNumber.valid_number?("+16045551234").should be_true
      PhoneNumber.valid_number?("+1 604 555 1234").should be_false
    end

    it "returns true when nil" do
      PhoneNumber.valid_number?(nil).should be_true
    end
  end

  describe ".format_number" do
    it "takes a north american number and formats it to E.164 format" do
      PhoneNumber.format_number("6045551234").should == "+16045551234"
      PhoneNumber.format_number("604-555-1234").should == "+16045551234"
      PhoneNumber.format_number("(604) 555-1234").should == "+16045551234"
      PhoneNumber.format_number("+1 (604) 555-1234").should == "+16045551234"
    end

    it "doesn't try when it is less than 10 characters" do
      PhoneNumber.format_number("604 1234").should == "604 1234"
    end
  end

  describe PhoneNumber::NullPhoneNumber do
    it "can be instantiated with an incoming number" do
      null_phone_number = PhoneNumber::NullPhoneNumber.new(incoming_number: "foobarbaz")
      null_phone_number.incoming_number.should == "foobarbaz"
    end
  end
end
