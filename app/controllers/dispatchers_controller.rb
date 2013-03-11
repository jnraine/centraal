class DispatchersController < ApplicationController
  def receive_call
    render :text => dispatcher.receive_call
  end

  def conclude_call
    render :text => dispatcher.conclude_call
  end

  def receive_voicemail
    voicemail = Voicemail.where(:call_sid => params["CallSid"]).first.tap do |vm|
      vm.recording_url = params["RecordingUrl"]
      vm.duration = params["RecordingDuration"]
      vm.save
    end
    
    render :text => dispatcher.hang_up
  end

  def receive_voicemail_transcription
    Voicemail.where(:call_sid => params["CallSid"]).first.tap do |vm|
      vm.transcription = params["TranscriptionText"]
      vm.save
    end

    render :text => ""
  end

  private

  def dispatcher
    @dispatcher ||= Dispatcher.new(params)
  end
end

# When call is answered and ends normally
{
  "AccountSid"=>"AC91a48b008deae010bf5c6f8982f79ff8", 
  "ToZip"=>"", 
  "FromState"=>"BC", 
  "Called"=>"+16042004455", 
  "FromCountry"=>"CA", 
  "CallerCountry"=>"CA", 
  "CalledZip"=>"", 
  "Direction"=>"inbound", 
  "FromCity"=>"VANCOUVER", 
  "CalledCountry"=>"CA", 
  "CallerState"=>"BC", 
  "DialCallDuration"=>"2", 
  "CallSid"=>"CA5d890b42aac898859663bebfc83d9c20", 
  "CalledState"=>"BC", 
  "From"=>"+17787823111", 
  "CallerZip"=>"", 
  "FromZip"=>"", 
  "ApplicationSid"=>"APc806364dd06a91015773cd5e2f36247f", 
  "CallStatus"=>"in-progress", 
  "DialCallSid"=>"CAbad36ec8bad94d22dce885a8a3e6186a", 
  "ToCity"=>"NEW WESTMINSTER", 
  "ToState"=>"BC", 
  "To"=>"+16042004455", 
  "ToCountry"=>"CA", 
  "DialCallStatus"=>"completed", 
  "CallerCity"=>"VANCOUVER", 
  "ApiVersion"=>"2010-04-01", 
  "Caller"=>"+17787823111", 
  "CalledCity"=>"NEW WESTMINSTER", 
  "controller"=>"dispatchers", 
  "action"=>"end_call"
}

# When call is declined (goes straight to voicemail on receivers end -- doesn't go back to twilio just yet)
{"AccountSid"=>"AC91a48b008deae010bf5c6f8982f79ff8", "ToZip"=>"", "FromState"=>"BC", "Called"=>"+16042004455", "FromCountry"=>"CA", "CallerCountry"=>"CA", "CalledZip"=>"", "Direction"=>"inbound", "FromCity"=>"VANCOUVER", "CalledCountry"=>"CA", "CallerState"=>"BC", "DialCallDuration"=>"10", "CallSid"=>"CAba6569717973f82fdc25ed0088a1916f", "CalledState"=>"BC", "From"=>"+17787823111", "CallerZip"=>"", "FromZip"=>"", "ApplicationSid"=>"APc806364dd06a91015773cd5e2f36247f", "CallStatus"=>"completed", "DialCallSid"=>"CA2170d8abb6eb68ca267b93c4ff666d6f", "ToCity"=>"NEW WESTMINSTER", "ToState"=>"BC", "To"=>"+16042004455", "ToCountry"=>"CA", "DialCallStatus"=>"completed", "CallerCity"=>"VANCOUVER", "ApiVersion"=>"2010-04-01", "Caller"=>"+17787823111", "CalledCity"=>"NEW WESTMINSTER", "controller"=>"dispatchers", "action"=>"end_call"}

# When call is not answered and times out (no-answer)
{"AccountSid"=>"AC91a48b008deae010bf5c6f8982f79ff8", "ToZip"=>"", "FromState"=>"BC", "Called"=>"+16042004455", "FromCountry"=>"CA", "CallerCountry"=>"CA", "CalledZip"=>"", "Direction"=>"inbound", "FromCity"=>"VANCOUVER", "CalledCountry"=>"CA", "CallerState"=>"BC", "CallSid"=>"CA8471ddb8c3d4feb28651525df1683e16", "CalledState"=>"BC", "From"=>"+17787823111", "CallerZip"=>"", "FromZip"=>"", "ApplicationSid"=>"APc806364dd06a91015773cd5e2f36247f", "CallStatus"=>"in-progress", "DialCallSid"=>"CA28debb7931b976c42d4c7706cb424fda", "ToCity"=>"NEW WESTMINSTER", "ToState"=>"BC", "To"=>"+16042004455", "ToCountry"=>"CA", "DialCallStatus"=>"no-answer", "CallerCity"=>"VANCOUVER", "ApiVersion"=>"2010-04-01", "Caller"=>"+17787823111", "CalledCity"=>"NEW WESTMINSTER", "controller"=>"dispatchers", "action"=>"end_call"}