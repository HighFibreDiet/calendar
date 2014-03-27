require 'active_record'
require './lib/event'
require 'date'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['development'])

def welcome
  system('clear')
  puts "========Welcome to the Calendar Machine========"
end

def menu
  puts "Type 'add' to add a new event."
  puts "Type 'exit' to exit the Calendar Machine."

  menu_choice = gets.chomp
  case menu_choice
  when 'add'
    add_event
  when 'exit'
    exit
  else
    puts "Not a valid choice."
  end
end

def add_event
  puts "\n\n=====Add Event=====\n\n"
  puts "Enter a description of the event: "
  print ">"
  description = gets.chomp
  puts "Enter the event's location: "
  print ">"
  location = gets.chomp
  start_date = get_start_date
  start_time = get_start_time
  start_datetime = "#{start_date} #{start_time}"
  end_date = get_end_date(start_date)
  end_time = get_end_time
  end_datetime = "#{end_date} #{end_time}"

  new_event = Event.new({:description => description, :location => location, :start_datetime => start_datetime, :end_datetime => end_datetime})

  if new_event.save
    puts "#{new_event.description} has been successfully added to the Calendar Machine."
  else
    puts "This event was not successfully created. The following errors occurred: "
    new_event.errors.full_messages.each { |message| puts message }
    add_event
  end

end

def get_start_date
  puts "Enter the start date (DD/MM/YYYY): "
  print ">"
  start_date = gets.chomp
  begin
    start_date = DateTime.parse(start_date)
  rescue
    puts "Please enter a valid date."
    get_start_date
  else
    start_date
  end
end

def get_start_time
  puts "Enter the start time (HH:MM - 24 hour format): "
  print ">"
  start_time = gets.chomp
  begin
    start_time = Time.parse(start_time)
  rescue
    puts "Please enter a valid time."
    get_start_time
  else
    start_time
  end
end

def get_end_date(start_date)
  puts "Is this a multi-day event? (Y/N)"
  multi_day = gets.chomp.downcase
  if multi_day == 'y'
    puts "Enter the end date (DD/MM/YYYY): "
    print ">"
    end_date = gets.chomp
    begin
      end_date = DateTime.parse(end_date)
    rescue
      puts "Please enter a valid date."
      get_end_date
    end
  else
    end_date = start_date
  end
  end_date
end

def get_end_time
  puts "Enter the end time (HH:MM - 24 hour format): "
  print ">"
  end_time = gets.chomp
  begin
    end_time = Time.parse(end_time)
  rescue
    puts "Please enter a valid time."
    get_end_time
  end
  end_time
end

welcome
loop do
  menu
end
