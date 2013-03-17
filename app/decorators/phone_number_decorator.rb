class PhoneNumberDecorator < Draper::Decorator
  delegate_all

  def incoming_number
    decorate_number(model.incoming_number)
  end

  def forwarding_number
    decorate_number(model.forwarding_number)
  end

  def voicemail
    if model.voicemail
      "On"
    else
      "Off"
    end
  end

  def forwarding
    if model.forwarding
      "On"
    else
      "Off"
    end
  end

  def decorate_number(number)
    number = prettify_number(number)
    if number.present?
      number
    else
      "<em>Not Set</em>".html_safe
    end
  end

  def prettify_number(number)
    return "" if number.nil?
    country_code = number[0..1]
    area_code = number[2..4]
    first_digits = number[5..7]
    last_digits = number[8..11]
    "#{country_code} (#{area_code}) #{first_digits}-#{last_digits}"
  end
end
