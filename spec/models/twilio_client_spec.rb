require 'spec_helper'

describe TwilioClient do
  let(:phone_number) { create(:phone_number) }
  let(:twilio_client) { create(:twilio_client, phone_number: phone_number) }

  it "belongs to a phone number" do
    twilio_client = TwilioClient.new(client_type: :js)
    twilio_client.phone_number = phone_number
    twilio_client.phone_number.should == phone_number
  end

  it "generates a token" do
    TwilioWrapper.instance.should_receive(:client_token).and_return(:some_client_token)
    twilio_client.token.should == :some_client_token
  end

  it "has an identifier" do
    twilio_client.client_type = "js"
    twilio_client.phone_number_id = 1
    twilio_client.identifier.should == "1-js"
  end

  describe "#ping" do
    it "sets the last ping date to now and saves the record" do
      twilio_client.should_receive(:last_ping=)
      twilio_client.ping
      twilio_client.should_not be_changed
    end
  end
end
