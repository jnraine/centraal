require 'spec_helper'

describe Dispatcher do
  let(:bobs_mobile) { "+15559876543" }
  let(:bobs_office) { "+15551234567" }
  let(:customer_joe)  { "+15557654321" }

  let(:phone) { FactoryGirl.create(:phone, incoming_number: bobs_office, forwarding_number: bobs_mobile) }

  let(:twilio_params) do
    {
      "To" => phone.incoming_number,
      "DialCallStatus" => "completed",
      "CallSid" => "unique sid",
      "From" => customer_joe
    }
  end

  let(:dispatcher) { Dispatcher.new(twilio_params) }

  describe ".unavailable_number" do
    it "tells caller the number is not available" do
      dispatcher.unavailable_number.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Say>1, 5, 5, 5, 1, 2, 3, 4, 5, 6, 7, is not available at this time. Sorry for any inconvenience. Good-bye.</Say></Response>"
    end
  end

  describe "#call_from_owner?" do
    let(:twilio_params) do
      {
        "To" => bobs_office,
        "From" => bobs_mobile
      }
    end

    it "returns true when 'from' number matches forwarding number for incoming number" do
      Phone.new.tap do |pn| 
        pn.incoming_number = bobs_office
        pn.forwarding_number = bobs_mobile
        pn.save!
      end

      dispatcher.call_from_owner?.should be_true
    end
  end

  describe "#forward_call" do
    it "gives me the XML I want to see" do
      dispatcher.phone.connect_client
      dispatcher.forward_call.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Dial action=\"/dispatchers/conclude_call\" method=\"get\" timeout=\"10\"><Number>+15559876543</Number><Client>1</Client></Dial></Response>"
    end
  end
end
