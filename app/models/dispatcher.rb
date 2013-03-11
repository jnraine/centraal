class Dispatcher
  attr_reader :phone_number, :dial_call_status, :from, :call_sid

  def initialize(params)
    @phone_number = retrieve_phone_number(params["To"])
    @dial_call_status = params["DialCallStatus"]
    @call_sid = params["CallSid"]
    @from = params["From"]
  end

  def retrieve_phone_number(incoming_phone_number)
    PhoneNumber.where(:incoming_number => incoming_phone_number).first || PhoneNumber.null_object(:incoming_number => incoming_phone_number)
  end

  def receive_call
    if phone_number.forwarding?
      forward_call
    elsif phone_number.has_voicemail?
      send_to_voicemail
    else
      unavailable_number
    end
  end

  def conclude_call
    if call_not_completed?
      send_to_voicemail
    else 
      hang_up
    end
  end

  def call_not_completed?
    dial_call_status != "completed"
  end

  def hang_up
    Twilio::TwiML::Response.new do |r|
      r.Hangup
    end.text
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def forward_call
    Twilio::TwiML::Response.new do |r|
      r.Dial phone_number.forwarding_number, {
        :action => url_helpers.conclude_call_path,
        :method => :get, 
        :timeout => 2
      }
    end.text
  end

  def send_to_voicemail
    Voicemail.create!(:call_sid => call_sid, :from => from, :phone_number => phone_number)
    Twilio::TwiML::Response.new do |r|
      r.Say "You have reached the voice mailbox for #{phone_number.speakable_incoming_number}. Please leave a message after the beep."
      r.Record action: url_helpers.receive_voicemail_path, method: :get, maxLength: 120, transcribe: true, transcribeCallback: url_helpers.receive_voicemail_transcription_path
    end.text
  end

  def unavailable_number
    Twilio::TwiML::Response.new do |r|
      r.Say "#{phone_number.incoming_number} is not available at this time. Sorry for any inconvenience"
    end.text
  end
end