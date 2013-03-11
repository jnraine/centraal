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