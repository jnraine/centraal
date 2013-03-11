class TwilioWrapper
  include Singleton

  def account
    @account ||= client.account
  end

  def client
    @client ||= ::Twilio::REST::Client.new(account_sid, auth_token)
  end

  def app
    account.applications.get(app_sid)
  end

  def app_sid
    TWILIO_SETTINGS["app_sid"]
  end

  def account_sid
    TWILIO_SETTINGS["account_sid"]
  end

  def auth_token
    TWILIO_SETTINGS["auth_token"]
  end

  def incoming_phone_numbers
    twilio_numbers = account.incoming_phone_numbers.list
    twilio_numbers.delete_if {|number| number.voice_application_sid != app_sid }
    twilio_numbers.map(&:phone_number)
  end
end