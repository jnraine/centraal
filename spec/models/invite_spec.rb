require 'spec_helper'

describe Invite do
  describe ".generate_token" do
    it "generates a 125 character token of alpha characters and assigned it to the token attribute" do
        invite = Invite.new
        invite.generate_token
        invite.token.length.should == 50
        invite.token.should match(/[a-zA-Z0-9]/)
    end
  end

  it "generates a token after create" do
    Invite.create.token.should_not be_nil
  end

  it "can be created with a phone ID and recipient" do
    invite = Invite.create(phone_id: 1, recipient: "bob@example.com")
    invite.token.should_not be_nil
    invite.recipient.should == "bob@example.com"
    invite.phone_id.should == 1
  end
end
