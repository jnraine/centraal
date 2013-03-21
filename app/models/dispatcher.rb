
class Dispatcher
  attr_reader :phone_number, :dial_call_status, :from, :call_sid, :outgoing_number, :digits, :recording_url, :recording_duration, :transcription_text

  def initialize(params)
    @phone_number = PhoneNumber.for_incoming_number(params["To"])
    @dial_call_status = params["DialCallStatus"]
    @call_sid = params["CallSid"]
    @from = params["From"]
    @outgoing_number = params["OutgoingNumber"]
    @digits = params["Digits"]
    @recording_url = params["RecordingUrl"]
    @recording_duration = params["RecordingDuration"]
    @transcription_text = params["TranscriptionText"]
  end

  def receive_call
    if outgoing_call?
      connect_call
    elsif call_from_owner?
      handle_call_from_owner
    elsif phone_number.forwarding?
      forward_call
    elsif phone_number.connected_clients.present?
      forward_call_to_client_only
    elsif phone_number.voicemail_on?
      record_voicemail
    else
      unavailable_number
    end
  end

  def conclude_call
    # need to handled concluded call initiated by web browser...
    # here's what the conclude params look like on a call that completed: {"AccountSid"=>"AC91a48b008deae010bf5c6f8982f79ff8", "ApplicationSid"=>"APc806364dd06a91015773cd5e2f36247f", "CallStatus"=>"completed", "DialCallSid"=>"CA7f45c929557dd9989a1b815e1f0d74c4", "To"=>"", "Called"=>"", "DialCallStatus"=>"completed", "Direction"=>"inbound", "ApiVersion"=>"2010-04-01", "Caller"=>"client:1", "CallSid"=>"CAdeffd0b414ed583edc4896ac3fb4235a", "DialCallDuration"=>"7", "From"=>"client:1"}
    # Gotta handle when I call someone from a browser and they don't answer
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

  def call_from_owner?
    phone_number.forwarding_number == from
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
    if phone_number.voicemail_greeting.present?
      Twilio::TwiML::Response.new do |r|
        r.Play phone_number.voicemail_greeting
        r.Redirect url_helpers.receive_call_path, method: :get
      end.text
    else
      Twilio::TwiML::Response.new do |r|
        r.Say "No voicemail greeting found for #{phone_number.speakable_incoming_number}"
        r.Redirect url_helpers.receive_call_path, method: :get
      end.text
    end
  end

  def receive_voicemail_greeting
    phone_number.voicemail_greeting = recording_url
    phone_number.save

    Twilio::TwiML::Response.new do |r|
      r.Say "Your new voicemail greeting has been saved."
      r.Redirect url_helpers.receive_call_path, method: :get
    end.text
  end

  def failed_to_receive_voicemail_greeting
    Twilio::TwiML::Response.new do |r|
      r.Say "A problem occurred while saving your voicemail greeting."
      r.Redirect url_helpers.receive_call_path, method: :get
    end.text
  end

  def forward_call
    Twilio::TwiML::Response.new do |r|
      r.Dial action: url_helpers.conclude_call_path, method: :get, timeout: 10 do
        r.Number phone_number.forwarding_number
        phone_number.connected_clients.each do |connected_client|
          r.Client connected_client.identifier
        end
      end
    end.text
  end

  def forward_call_to_client_only
    Twilio::TwiML::Response.new do |r|
      r.Dial action: url_helpers.conclude_call_path, method: :get, timeout: 10 do
        phone_number.connected_clients.each do |connected_client|
          r.Client connected_client.identifier
        end
      end
    end.text
  end

  def connect_call
    phone_number = PhoneNumber.find(from.gsub("client:", ""))
    Twilio::TwiML::Response.new do |r|
      r.Dial outgoing_number, {
        action: url_helpers.conclude_call_path, 
        "callerId" => phone_number.incoming_number
      }
    end.text
  end

  def receive_voicemail
    Voicemail.for_call_sid(call_sid).tap do |vm|
      vm.from = from
      vm.phone_number = phone_number
      vm.recording_url = recording_url
      vm.duration = recording_duration
      
      if vm.save
        # all good, noop
      else
        Rails.logger.error "Unable to save voicemail: #{vm.errors.inspect}"
      end
    end

    hang_up
  end

  def recoive_voicemail_transcription
    Voicemail.for_call_sid(call_sid).tap do |vm|
      vm.transcription = transcription_text
      vm.save
    end

    ""
  end

  def record_voicemail
    Twilio::TwiML::Response.new do |r|
      if phone_number.voicemail_greeting.present?
        r.Play phone_number.voicemail_greeting
      else
        r.Say "You have reached the voice mailbox for #{phone_number.speakable_incoming_number}. Please leave a message after the beep."
      end

      record_options = {
        action: url_helpers.receive_voicemail_path, 
        method: :get, 
        maxLength: 120,
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
