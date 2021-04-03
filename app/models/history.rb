class History < ApplicationRecord

  def provider
    if is_cvs
      'cvs'
    elsif is_health_mart
      'health_mart'
    elsif is_rite_aid
      'riteaid'
    elsif is_walgreens
      'walgreens'
    elsif is_walmart
      'walmart'
    else
      'no provider recorded'
    end
  end
end
