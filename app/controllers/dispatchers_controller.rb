class DispatchersController < ApplicationController
  def receive_call
    render :text => dispatcher.receive_call
  end

  def conclude_call
    render :text => dispatcher.conclude_call
  end

  def receive_voicemail
    render :text => dispatcher.receive_voicemail
  end

  def receive_voicemail_transcription
    render :text => dispatcher.receive_voicemail_transcription
  end

  def receive_voicemail_greeting
    render :text => dispatcher.receive_voicemail_greeting
  end

  def process_owner_gather
    render :text => dispatcher.process_owner_gather
  end

  private
  def dispatcher
    @dispatcher ||= Dispatcher.new(params)
  end
end