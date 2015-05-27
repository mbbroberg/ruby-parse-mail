#!/usr/bin/env ruby

# Usage: ./parse_mbox.rb mailing_list.mbox
# The input file should be in Mbox http://www.qmail.org/man/man5/mbox.html format
# For Mailman/pipermail type mailing lists, you can retrieve them (if you're a list member) at:
# http://www.example.com/mailman/private/<listname>.mbox/<listname>.mbox

################ REPORTING ###################
# What am I trying to report on? 
# 
# On threads: 
# => Are any orphaned?
# => Are any unanswered? 
# => Answered by Basho or Other?
#
#
# On Users: 
# => Are they active? (answer is yes if they're in here. Could compare to # of members from elsewhere)
# => Do they ask questions?
# => Do they answer questions? 
###############################################

require 'mail'
require 'csv'

if ARGV.size < 1
  puts "ERROR: Need more input. You must include the mbox to parse."
  puts "You can also output to CSV with --format=csv"
  exit 
end

file_name = ARGV[0]
format = ARGV[1]
senders = {}
msg_count = 0
process_limit_num = 1000  # Only parse the first N messages
                          # Default is set to 100 so you don't   


puts "Parsing #{file_name}..."

## Testing note.
if process_limit_num < 100000000000
    puts "Your process_limit_num is set to #{process_limit_num}."
    puts "It looks like you're in testing mode."
    puts "You may want to increase it to some absurd number to parse the whole file."
end

File.open(file_name,"r:iso-8859-2").slice_before(/^From /).each do | lines |
  # Drop the first line since it's the mbox-specific 'From ...@... Sun Aug 09 23:07:58 2009'
  message_text = lines.join()

  # Parse the message text into a Mail object instance
  msg = Mail.new(message_text)
  puts msg.subject

  # Step 1:
  # msg.to 
  # msg.from
  # Parse them for Basho or not
  #   >> mail.from[0].split("@")
  #   => ["tarvid", "ls.net"]


  # Step 2: 
  # if the msg.subject is `ss:` it covers RE: and SV: and is a reply
  

  # Step 3:
  # Keep a histogram of senders
  from = msg.header['from'].to_s
  if senders.has_key? from
    senders[from] += 1
  else
    senders[from] = 1 
  end

  # Step 4: 
  # Keep a tally total of messages 
  msg_count += 1
  if msg_count >= process_limit_num
    break
  end
end

puts "-----------------------------------------------------------------------------"
puts "| Total messages: #{msg_count} from #{senders.size} distinct authors |"
puts "-----------------------------------------------------------------------------"

#### Print out the senders and # of emails they sent, in ascending order
# puts senders.sort_by { |k,v| v }

if format == "--format=csv"
  puts "Printing out to CSV as well."
  s=CSV.generate do |csv|
    csv << ["Sender", "Tally", "Total Messages", "Total Senders"] # Name the columns
    csv << ["","",msg_count, senders.size]
    senders.each do |x|
      new_x = []
      if x[0]
        new_x[0] = x[0].sub('<', ', ').sub('>', '') # strip brackets in a safe way
        new_x[0].gsub!(/"/, '')
      end
      if x[1].class == String
        new_x[1] = x[1].downcase                  # If x[1] exists and it's a string, then we can normalize to down
      end
      csv << new_x
    end
  end
  File.write('the_file.csv', s)
end