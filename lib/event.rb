require 'pry'

class Event < ActiveRecord::Base
  I18n.enforce_available_locales = false
  validates :description, :presence => true, :length => { :maximum => 30 }
  validates :location, :presence => true, :length => { :maximum => 25 }
  validates :start_datetime, :presence => true
  validates :end_datetime, :presence => true
  validate :start_datetime_before_end_datetime

private
  def start_datetime_before_end_datetime
    unless start_datetime.nil? || end_datetime.nil?
      if start_datetime > end_datetime
        errors.add(:end_datetime, "An event can't end before it starts")
      end
    end
  end
end
