class PhoneNumbersController < ApplicationController
  def index
    @phone_numbers = PhoneNumber.scoped.decorate
  end

  def edit
    @phone_number = PhoneNumber.find(params[:id]).decorate
  end

  def update
    @phone_number = PhoneNumber.find(params[:id]).decorate

    if @phone_number.update_attributes(params[:phone_number])
      flash[:notice] = "#{@phone_number.incoming_number} updated"
      redirect_to phone_numbers_path
    else
      flash[:error] = "Problem saving #{@phone_number.incoming_number}"
      render :edit
    end
  end

  def sync
    count_before_sync = PhoneNumber.count
    PhoneNumber.sync_numbers
    count_after_sync = PhoneNumber.count
    
    if count_before_sync == count_after_sync
      flash[:notice] = "No new numbers added from Twilio"
    else
      difference = count_after_sync - count_before_sync
      flash[:notice] = "#{difference} phone numbers synced from Twilio"
    end

    redirect_to phone_numbers_path
  end
end
