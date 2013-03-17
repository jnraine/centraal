require 'spec_helper'

describe PhoneNumber do
  describe ".import_numbers" do
    it "can import phone numbers from Twilio" do
      TwilioWrapper.instance.should_receive(:incoming_phone_numbers).and_return(["one", "two"])
      PhoneNumber.import_numbers
      PhoneNumber.count.should == 2
      PhoneNumber.first.incoming_number.should == "one"
    end

    it "creates records only for numbers that don't already exist" do
      TwilioWrapper.instance.should_receive(:incoming_phone_numbers).and_return(["one", "two"])
      existing_number = PhoneNumber.new.tap {|p| p.incoming_number = "one"; p.save! }
      PhoneNumber.import_numbers
      PhoneNumber.where(:incoming_number => "one").count.should == 1
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
