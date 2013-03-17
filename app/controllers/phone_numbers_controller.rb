class PhoneNumbersController < ApplicationController
  def index
    @phone_numbers = PhoneNumber.scoped.decorate
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
