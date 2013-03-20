class VoicemailsController < ApplicationController
  def play
    @voicemail = Voicemail.find(params[:id])
    redirect_to @voicemail.recording_url
  end

  def mark_as_read
    @voicemail = Voicemail.find(params[:id])
    if @voicemail.mark_as_read
      render :text => "Marked as read"
    else
      render :text => "A problem occurred"
    end
  end
end
