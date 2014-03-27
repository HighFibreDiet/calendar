require 'active_record'
require './lib/event'
require 'date'
Time.zone = 'America/Los_Angeles'
require 'validates_timeliness'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['development'])

def welcome
  system('clear')
  puts "========Welcome to the Calendar Machine========"
end

def menu
  puts "Type 'add' to add a new event."
  puts "Type 'edit' to edit an existing event"
  puts "Type 'list' to see all of your upcoming events."
  puts "Type 'options' to see more options."
  puts "Type 'exit' to exit the Calendar Machine."

  menu_choice = gets.chomp
  case menu_choice
  when 'add'
    add_event
  when 'edit'
    edit_event
  when 'list'
    list_events(true)
  when 'options'
    options_menu
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
    puts "'#{new_event.description}' at #{new_event.start_datetime} has been successfully added to the Calendar Machine."
  else
    puts "WARNING! This event was NOT successfully created. The following errors occurred: "
    new_event.errors.full_messages.each { |message| puts message }
    add_event
  end
end

def edit_event
  list_events(false)
  puts "Enter the ID of the event you would like to edit"
  print ">"
  event_id = gets.chomp.to_i
  event_to_edit = Event.find(event_id)
  continue = nil
  until continue == 'n'
    puts "\n\n-Event To Edit-\n"
    puts "Description: #{event_to_edit.description}"
    puts "Location: #{event_to_edit.location}"
    puts "Start: #{event_to_edit.start_datetime.strftime("%m/%d/%y at %I:%M%p")}"
    puts "End: #{event_to_edit.end_datetime.strftime("%m/%d/%y at %I:%M%p")}"
    puts "Enter the field you would like to edit."
    print ">"
    edit_choice = gets.chomp.downcase
    attributes = {'description' => :description, 'location' => :location, 'start' => :start_datetime, 'end' => :end_datetime}
    formats = {'description' => '', 'location' => '', 'start' => ' (MM/DD/YYYY HH:MM)', 'end' => ' (MM/DD/YYYY HH:MM)'}
    if !attributes[edit_choice].nil?
      if edit_choice == 'start'
        new_start_date = get_start_date
        new_start_time = get_start_time
        updated_field = "#{new_start_date} #{new_start_time}"
      elsif edit_choice == 'end'
        new_end_date = get_end_date('#{event_to_edit.start_datetime.strfdate("%d/%m/%y")}')
        new_end_time = get_end_time
        updated_field = "#{new_end_date} #{new_end_time}"
      else
        puts "Enter the new value for #{edit_choice}#{formats[edit_choice]}: "
        updated_field = gets.chomp
      end
      if !event_to_edit.update(attributes[edit_choice] => updated_field)
        puts "WARNING! This event was NOT successfully updated. The following errors occurred: "
        event_to_edit.errors.full_messages.each { |message| puts message }
      end
    else
      puts "Not a valid choice."
    end
    puts "Do you want to edit another field? (Y/N)"
    continue = gets.chomp.downcase
  end
end

def list_events(flag)
  puts "*************Your Events***********\n"
  events_in_order = Event.order(:start_datetime, :end_datetime)
  puts "\n\n"
  events_in_order.each do |event|
    if (event.start_datetime >= DateTime.now) && flag
      length = event.description.length
      padding = 25 - length
      if event.id < 10
        event_id_format = "#{0}#{event.id}"
      else
        event_id_format = "#{event.id}"
      end
      puts "ID #{event_id_format}: #{event.description}: #{" "*padding} #{event.start_datetime.strftime("%m/%d/%y at %I:%M%p")} to #{event.end_datetime.strftime("%m/%d/%y at %I:%M%p")}.\n"
    elsif !flag
      puts "ID #{event_id_format}: #{event.description}: #{" "*padding} #{event.start_datetime.strftime("%m/%d/%y at %I:%M%p")} to #{event.end_datetime.strftime("%m/%d/%y at %I:%M%p")}.\n"
    end
  end
  puts "\n\n"
end

def options_menu
  puts "===========Options Menu==========="
  puts "\n\nType 'month' to see events for the current month."
  puts "Type 'week' to see events for the current week."
  puts "Type 'today' to see today's events."
  puts "Type 'main' to return to the main menu."
  print ">"
  option_choice = gets.chomp
  case option_choice
  when 'month'
    view_by_month
  when 'week'
    view_by_week
  when 'today'
    view_by_day
  when 'main'
    main
  else
    puts "That was not a valid choice."
    options_menu
  end
end

def view_by_month
  today = DateTime.now
  puts "\n\n*******#{today.strftime('%B')} Events********\n\n"
  month_events = Event.by_month(today.month)
  puts month_events.first.description
end

def view_by_week
end

def view_by_day
end

def get_start_date
  puts "Enter the start date (MM/DD/YYYY): "
  print ">"
  start_date = gets.chomp
  begin
    start_date = Date.strptime(start_date, '%m/%d/%Y')
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
    Time.parse(start_time)
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
    puts "Enter the end date (MM/DD/YYYY): "
    print ">"
    end_date = gets.chomp
    begin
      end_date = Date.strptime(end_date, '%m/%d/%Y')
    rescue
      puts "Please enter a valid date."
      get_end_date
    end
  elsif multi_day == 'n'
    end_date = start_date
  else
    puts "Not a valid input."
    get_end_date(start_date)
  end
  end_date
end

def get_end_time
  puts "Enter the end time (HH:MM - 24 hour format): "
  print ">"
  end_time = gets.chomp
  begin
    Time.parse(end_time)
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
