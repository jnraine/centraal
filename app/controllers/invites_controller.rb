class InvitesController < ApplicationController
  before_filter :require_admin

  def create
    @invite = Invite.create(phone_id: params[:phone_id], recipient: params[:recipient])  

    if @invite.present?
      Rails.logger.info InviteMailer.invite_email(@invite).deliver.inspect
      flash[:notice] = "Invitation delivered to #{@invite.recipient}"
    else
      flash[:error] = "Something went wrong while creating the invite"
    end

    redirect_to phones_path
  end

  def accept
    @invite = Invite.for_token(params[:token])
    
    if @invite.present?
      @invite.tap do |i|
        i.phone.owner = current_user
        i.phone.save
        i.destroy
      end

      flash[:notice] = "Welcome to Centraal!"

      redirect_to root_path
    else
      render text: "Something went wrong!"
    end
  end
end
