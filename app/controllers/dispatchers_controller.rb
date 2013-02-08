class DispatchersController < ApplicationController
  def receive_call
    response_text = Twilio::TwiML::Response.new do |r|
      r.Dial '+16048072726', :action => "/dispatchers/end_call", :method => :get, :timeout => 10
      r.Say 'This shouldn\'t be said'
    end.text

    render :text => response_text
  end

  def end_call
    raise params.inspect
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

# When call is not answered and times out
