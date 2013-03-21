class TwilioClientsController < ApplicationController
  def ping
    twilio_client = TwilioClient.for(params[:id])
    twilio_client.ping if twilio_client.present?
    render text: ""
  end
end
