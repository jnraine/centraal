class TwilioClient < ActiveRecord::Base
  attr_accessible :last_ping
  belongs_to :phone

  def self.for(identifier)
    where(phone_id: identifier).first
  end

  def token
    TwilioWrapper.instance.client_token(identifier)
  end

  def identifier
    phone_id.to_s
  end

  def ping
    self.last_ping = Time.now
    save
  end
end
