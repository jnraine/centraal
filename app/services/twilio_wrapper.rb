require 'singleton'

class TwilioWrapper
  include Singleton
  
  def send_sms(options)
    account.sms.messages.create(from: options.fetch(:from), to: options.fetch(:to), body: options.fetch(:body))
  end

  # def call(recipient_number, call_params)
  #   account.calls.create({:from => dispatch_number, :to => recipient_number, :url => call_params[:url]})
  # end

  def account
    @account ||= client.account
  end

  def client
    @client ||= ::Twilio::REST::Client.new(account_sid, auth_token)
  end

  def app
    account.applications.get(app_sid)
  end

  def client_token(client_name)
    Twilio::Util::Capability.new(account_sid, auth_token).tap do |c|
      c.allow_client_outgoing(app_sid)
      c.allow_client_incoming(client_name)
    end.generate
  end

  def app_sid
    setting "app_sid"
  end

  def account_sid
    setting "account_sid"
  end

  def auth_token
    setting "auth_token"
  end

  def incoming_numbers
    twilio_numbers = account.incoming_phone_numbers.list
    twilio_numbers.delete_if {|number| number.voice_application_sid != app_sid }
    twilio_numbers.map(&:phone_number)
  end

  def total_price_since(date)
    account.usage.records.list(category:"totalprice", start_date: date).first.price
  end

  def total_voice_minutes
    account.usage.records.all_time.list(category:"calls").first.usage
  end

  def total_sms_messages
    account.usage.records.all_time.list(category:"sms").first.usage
  end

  def last_month_total_price
    account.usage.records.last_month.list(category:"totalprice").first.price
  end

  def setting(name)
    ENV[setting_key(name)]
  end

  def setting_set(name, value)
    ENV[setting_key(name)] = value
  end

  def setting_key(name)
    "TWILIO_#{name.upcase}"
  end
end
