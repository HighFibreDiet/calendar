require 'spec_helper'

describe Event do
  subject { Event.new(:start_datetime => DateTime.now, :end_datetime => DateTime.now) }
  it { should validate_presence_of :description }
  it { should ensure_length_of(:description).is_at_most(30) }
  it { should validate_presence_of :location }
  it { should ensure_length_of(:location).is_at_most(25) }
  it { should validate_presence_of :start_datetime }
  it { should validate_presence_of :end_datetime }

  describe 'start_datetime_before_end_datetime' do
    it 'validates that start_datetime occurs prior to end_datetime.' do
      start_datetime = "21/12/1986 01:30:00"
      end_datetime = "01/12/1986 00:00:30"
      event1 = Event.new(:description => "Test1", :location => "Test1", :start_datetime => start_datetime, :end_datetime => end_datetime)
      event1.save.should eq false
    end
  end
end
