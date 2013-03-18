class DispatchersController < ApplicationController
  def receive_call
    puts dispatcher.receive_call.inspect
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

  def receive_voicemail_greeting
    dispatcher.phone_number.voicemail_greeting = params["RecordingUrl"]
    render :text => dispatcher.receive_voicemail_greeting
  end

  def process_owner_gather
    puts params.inspect
    render :text => dispatcher.process_owner_gather
  end

  private

  def dispatcher
    @dispatcher ||= Dispatcher.new(params)
  end
end