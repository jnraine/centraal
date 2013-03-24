class PhonesController < ApplicationController
  before_filter :require_admin, except: [:show, :update]

  def index
    @phones = Phone.scoped.decorate
  end

  def show
    @phone = Phone.find(params[:id]).decorate
  end

  def edit
    @phone = Phone.find(params[:id]).decorate
  end

  def update
    @phone = Phone.find(params[:id]).decorate # I'm a security hole...

    respond_to do |format|
      if @phone.update_attributes(params[:phone])
        flash[:notice] = "#{@phone.incoming_number} updated"
        format.html { redirect_to phones_path }
        format.json { render json: {phone: @phone, flash: flash} }
      else
        flash[:error] = "Problem saving #{@phone.incoming_number}"
        format.html { render :edit }
        format.json { render json: {phone: @phone, flash: flash} }
      end
    end
  end

  def sync
    count_before_sync = Phone.count
    Phone.sync_numbers
    count_after_sync = Phone.count
    
    if count_before_sync == count_after_sync
      flash[:notice] = "No new numbers added from Twilio"
    else
      difference = count_after_sync - count_before_sync
      flash[:notice] = "#{difference} phones synced from Twilio"
    end

    redirect_to phones_path
  end

  def zero
    redirect_to front_door_redirect unless current_user.phones.zero?
  end
end