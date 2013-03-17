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

  def import
    count_before_import = PhoneNumber.count
    PhoneNumber.import_numbers
    count_after_import = PhoneNumber.count
    
    if count_before_import == count_after_import
      flash[:notice] = "No new numbers added from Twilio"
    else
      difference = count_after_import - count_before_import
      flash[:notice] = "#{difference} phone numbers imported from Twilio"
    end

    redirect_to phone_numbers_path
  end
end
