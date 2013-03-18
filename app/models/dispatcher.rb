class Dispatcher
  attr_reader :phone_number, :dial_call_status, :from, :call_sid, :outgoing_number, :digits

  def initialize(params)
    @phone_number = retrieve_phone_number(params["To"])
    @dial_call_status = params["DialCallStatus"]
    @call_sid = params["CallSid"]
    @from = params["From"]
    @outgoing_number = params["OutgoingNumber"]
    @digits = params["Digits"]
  end

  def retrieve_phone_number(incoming_phone_number)
    PhoneNumber.where(:incoming_number => incoming_phone_number).first || PhoneNumber.null_object(:incoming_number => incoming_phone_number)
  end

  def receive_call
    if outgoing_call?
      connect_call
    elsif call_from_owner?
      handle_call_from_owner
    elsif phone_number.forwarding?
      forward_call
    elsif phone_number.voicemail_on?
      record_voicemail
    else
      unavailable_number
    end
  end

  def conclude_call
    if call_not_completed?
      record_voicemail
    else 
      hang_up
    end
  end

  def outgoing_call?
    outgoing_number.present?
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

  def handle_call_from_owner
    Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: 1, action: url_helpers.process_owner_gather_path do
        r.Say "Press 1 to record a new voicemail greeting"
        r.Say "Press 2 to listen to your voicemail greeting"
      end
    end.text
  end

  def process_owner_gather
    if digits == "1"
      record_voicemail_greeting
    elsif digits == "2"
      play_voicemail_greeting
    else
      Twilio::TwiML::Response.new do |r|
        r.Say "Sorry, I don't know what to do with #{digits}"
        r.Redirect receive_call_path, method: :get
      end.text
    end
  end

  def record_voicemail_greeting
    Twilio::TwiML::Response.new do |r|
      r.Say "Record a voicemail greeting after the beep. Press any key to stop recording."
      record_options = {action: url_helpers.receive_voicemail_greeting_path, maxLength: 120}
      r.Record record_options
    end.text
  end

  def play_voicemail_greeting
    Twilio::TwiML::Response.new do |r|
      r.Play phone_number.voicemail_greeting
      r.Redirect receive_call_path, method: :get
    end.text
  end

  def receive_voicemail_greeting
    Twilio::TwiML::Response.new do |r|
      r.Say "Your new voicemail greeting has been saved."
      r.Redirect receive_call_path, method: :get
    end.text
  end

  def forward_call
    Twilio::TwiML::Response.new do |r|
      r.Dial phone_number.forwarding_number, {
        :action => url_helpers.conclude_call_path,
        :method => :get, 
        :timeout => 10
      }
    end.text
  end

  def connect_call
    Twilio::TwiML::Response.new do |r|
      r.Dial outgoing_number, {
        :action => url_helpers.conclude_call_path, 
        "callerId" => PhoneNumber.first.incoming_number
      }
    end.text
  end

  def record_voicemail
    Voicemail.create!(:call_sid => call_sid, :from => from, :phone_number => phone_number)
    Twilio::TwiML::Response.new do |r|
      if phone_number.voicemail_greeting.present?
        r.Say "You have reached the voice mailbox for #{phone_number.speakable_incoming_number}. Please leave a message after the beep."
      else
        r.Play phone_number.voicemail_greeting
      end

      record_options = {
        action: url_helpers.receive_voicemail_path, 
        method: :get, 
        maxLength: 120, 
        transcribe: true, 
        transcribeCallback: url_helpers.receive_voicemail_transcription_path
      }
      r.Record record_options
    end.text
  end

  def unavailable_number
    Twilio::TwiML::Response.new do |r|
      r.Say "#{phone_number.speakable_incoming_number}, is not available at this time. Sorry for any inconvenience. Good-bye."
    end.text
  end
end