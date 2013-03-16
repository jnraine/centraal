require 'spec_helper'

describe Dispatcher do
  let(:twilio_params) do
    {
      "To" => "+15551234567",
      "DialCallStatus" => "completed",
      "CallSid" => "unique sid",
      "From" => "+15557654321"
    }
  end

  let(:dispatcher) { Dispatcher.new(twilio_params) }

  describe ".unavailable_number" do
    it "tells caller the number is not available" do
      dispatcher.unavailable_number.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Say>+15551234567 is not available at this time. Sorry for any inconvenience</Say></Response>"
    end
  end
end