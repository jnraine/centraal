class PhonesController < ApplicationController
  before_filter :require_admin, except: [:update, :user, :zero]

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
        flash.now[:notice] = "#{@phone.incoming_number} updated"
      else
        flash.now[:error] = "Problem saving #{@phone.incoming_number}"
      end

      format.json { render json: {phone: @phone, flash: flash, errors: @phone.errors.messages} }
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
    redirect_to root_path unless current_user.phones.length.zero?
  end

  def user
    if current_user.phones.present?
      @phone = current_user.phones.first.decorate
      render :show
    else
      redirect_to root_path
    end
  end
end
