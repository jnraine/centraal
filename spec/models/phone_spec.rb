require 'spec_helper'

describe Phone do
  let(:bobs_office) { "+15551234567" }
  let(:amys_office) { "+15557654321" }

  describe ".sync_numbers" do
    it "can sync missing phone numbers from Twilio" do
      TwilioWrapper.instance.should_receive(:incoming_numbers).and_return([bobs_office, amys_office])
      Phone.sync_numbers
      Phone.count.should == 2
      Phone.all.map(&:incoming_number).should == [bobs_office, amys_office]
    end

    it "creates records only for numbers that don't already exist" do
      TwilioWrapper.instance.should_receive(:incoming_numbers).and_return([bobs_office, amys_office])
      existing_number = Phone.new.tap {|p| p.incoming_number = bobs_office; p.save! }
      Phone.sync_numbers
      Phone.where(incoming_number: bobs_office).count.should == 1
    end
  end

  it "defaults forwarding to false" do
    Phone.new.forwarding? == false
  end

  describe ".valid_number?" do
    it "returns true when a number is in E.164 format" do
      Phone.valid_number?("+16045551234").should be_true
      Phone.valid_number?("+1 604 555 1234").should be_false
    end

    it "returns true when nil" do
      Phone.valid_number?(nil).should be_true
    end
  end

  describe ".format_number" do
    it "takes a north american number and formats it to E.164 format" do
      Phone.format_number("6045551234").should == "+16045551234"
      Phone.format_number("604-555-1234").should == "+16045551234"
      Phone.format_number("(604) 555-1234").should == "+16045551234"
      Phone.format_number("+1 (604) 555-1234").should == "+16045551234"
    end

    it "doesn't try when it is less than 10 characters" do
      Phone.format_number("604 1234").should == "604 1234"
    end
  end

  describe Phone::NullPhone do
    it "can be instantiated with an incoming number" do
      null_phone = Phone::NullPhone.new(incoming_number: "foobarbaz")
      null_phone.incoming_number.should == "foobarbaz"
    end
  end

  describe ".for_incoming_number" do
    it "returns a phone number instance when it existst" do
      existing = Phone.new.tap {|pn| pn.incoming_number = bobs_office; pn.save! }
      Phone.for_incoming_number(bobs_office).should == existing
    end

    it "returns a null phone number instance with matching incoming number when a record doesn't exist for incoming number" do
      Phone.for_incoming_number(bobs_office).incoming_number.should == bobs_office
    end
  end

  describe "#connect_client" do
    it "takes a client type, creates an associated client, and pings the client" do
      phone = create(:phone)
      phone.connect_client
      phone.clients.should have(1).item
    end
  end

  describe "connected_clients" do
    it "returns all clients that have pinged in the last 5 minutes" do
      phone = create(:phone)
      phone.clients.build(last_ping: 10.minutes.ago)
      phone.connect_client
      phone.clients.should have(2).item
      phone.connected_clients.should have(1).item
    end
  end
end
