class TwilioClient < ActiveRecord::Base
  attr_accessible :client_type, :last_ping
  belongs_to :phone_number

  def self.for(identifier)
    phone_number_id = identifier
    where(phone_number_id: phone_number_id).first
  end

  def token
    TwilioWrapper.instance.client_token(identifier)
  end

  def identifier
    phone_number_id
  end

  def ping
    self.last_ping = Time.now
    save
  end
end
