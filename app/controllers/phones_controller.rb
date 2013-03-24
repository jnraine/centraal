class PhonesController < ApplicationController
  def index
    @phones = Phone.scoped.decorate
  end

  def edit
    @phone = Phone.find(params[:id]).decorate
  end

  def update
    @phone = Phone.find(params[:id]).decorate

    if @phone.update_attributes(params[:phone])
      flash[:notice] = "#{@phone.incoming_number} updated"
      redirect_to phones_path
    else
      flash[:error] = "Problem saving #{@phone.incoming_number}"
      render :edit
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

    redirect_to phone_numbers_path
  end
end
