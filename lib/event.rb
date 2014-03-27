class Event < ActiveRecord::Base
  I18n.enforce_available_locales = false
  validates :description, :presence => true, :length => { :maximum => 30 }
  validates :location, :presence => true, :length => { :maximum => 25 }
  validates :start_datetime, :presence => true
  validates :end_datetime, :presence => true

# private
#   def start_datetime_is_valid_datetime
#     if !start_datetime.is_a?(DateTime)
#       errors.add(:start_datetime, 'must be a valid datetime')
#       false
#     # else
#     #   true
#     end
#   end
end
