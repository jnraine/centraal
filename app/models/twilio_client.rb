class TwilioClient < ActiveRecord::Base
  attr_accessible :client_type, :last_ping
  belongs_to :phone_number

  def self.for(identifier)
    phone_number_id, client_type = identifier.split("-")
    where(phone_number_id: phone_number_id, client_type: client_type).first
  end

  def token
    TwilioWrapper.instance.client_token(identifier)
  end

  def identifier
    [phone_number_id, client_type].join("-")
  end

  def ping
    self.last_ping = Time.now
    save
  end
end
