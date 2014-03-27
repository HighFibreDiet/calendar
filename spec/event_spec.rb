require 'spec_helper'

describe Event do
  it { should validate_presence_of :description }
  it { should ensure_length_of(:description).is_at_most(30) }
  it { should validate_presence_of :location }
  it { should ensure_length_of(:location).is_at_most(25) }
  it { should validate_presence_of :start_datetime }
  it { should validate_presence_of :end_datetime }

  # describe 'start_datetime_is_valid_datetime' do
  #   it 'validates that start_datetime is an instance of DateTime.' do
  #     start_datetime1 = DateTime.parse("21/12/1986 01:30:00")
  #     p start_datetime1
  #     p start_datetime1.class
  #     start_datetime2 = DateTime.parse("31/01/2014")
  #     start_datetime3 = DateTime.parse("Yellow")
  #     event1 = Event.new(:description => "Test1", :location => "Test1", :start_datetime => start_datetime1)
  #     event2 = Event.new(:description => "Test2", :location => "Test2", :start_datetime => start_datetime2)
  #     event3 = Event.new(:description => "Test3", :location => "Test3", :start_datetime => start_datetime3)
  #     event1.save.should eq true
  #     event2.save.should eq true
  #     event3.save.should eq false
  #   end
  # end
end
