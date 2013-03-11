require 'spec_helper'

describe Dispatcher do
  describe ".unavailable_number" do
    it "tells caller the number is not available" do
      Dispatcher.unavailable_number({:to => "+15551234567"}).should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Say>+15551234567 is not available at this time. Sorry for any inconvenience</Say></Response>"
    end
  end
end