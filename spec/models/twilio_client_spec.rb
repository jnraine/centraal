require 'spec_helper'

describe TwilioClient do
  let(:phone) { create(:phone) }
  let(:twilio_client) { create(:twilio_client, phone: phone) }

  it "belongs to a phone" do
    twilio_client = TwilioClient.new
    twilio_client.phone = phone
    twilio_client.phone.should == phone
  end

  it "generates a token" do
    TwilioWrapper.instance.should_receive(:client_token).and_return(:some_client_token)
    twilio_client.token.should == :some_client_token
  end

  it "has an identifier" do
    twilio_client.phone_id = 1
    twilio_client.identifier.should == "1"
  end

  describe "#ping" do
    it "sets the last ping date to now and saves the record" do
      twilio_client.should_receive(:last_ping=)
      twilio_client.ping
      twilio_client.should_not be_changed # just checking if it has been saved
    end
  end
end
