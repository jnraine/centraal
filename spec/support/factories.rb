FactoryGirl.define do
  factory :phone_number do
    incoming_number "+15551234567"
  end

  factory :twilio_client do
    client_type "js"
  end
end
