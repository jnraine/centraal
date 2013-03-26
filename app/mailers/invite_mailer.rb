class InviteMailer < ActionMailer::Base
  default from: "noreply@sfu.ca"

  def invite_email(invite)
    @invite = invite
    @url = accept_invitation_url(@invite.token)
    mail(:to => invite.recipient, :subject => "Invitation to Centraal")
  end
end
