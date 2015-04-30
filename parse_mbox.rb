#!/usr/bin/env ruby

# Usage: ./parse_mbox.rb mailing_list.mbox
# The input file should be in Mbox http://www.qmail.org/man/man5/mbox.html format

# For Mailman/pipermail type mailing lists, you can retrieve them (if you're a list member) at:
# http://www.example.com/mailman/private/<listname>.mbox/<listname>.mbox

require 'mail'
require 'csv'

if ARGV.size < 1
  puts "ERROR: Need more input. You must include the mbox to parse."
  puts "You can also output to CSV with --format=csv --output=output.csv"
  exit 
end

#### Trying to use regex to parse ARGV but didn't work. 
# for each in ARGV
#   if each == /mbox/
#     mbox_file = each
#   elsif each == /--format/
#     format = each 
#   elsif each == /--output/
#     output_file = each
#   end
# end
#####

mbox_file = ARGV[0]
format = ARGV[1]
output_file = ARGV[2]
senders = {}
msg_count = 0
puts "Parsing #{mbox_file}..."  


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


##### Purely for testing #########
process_limit_num = 1000         # Only parse the first N messages

if process_limit_num < 100000000000 # Recommend setting to 100 so you don't  have to wait a while 
    puts "Your process_limit_num is set to #{process_limit_num}."
    puts "It looks like you're in testing mode."
    puts "You may want to increase it to some absurd number to parse the whole file."
end
##################################

######## Start Parsing ###########

File.open(mbox_file,"r:iso-8859-2").slice_before(/^From /).each do | lines |
  # Drop the first line since it's the mbox-specific 'From ...@... Sun Aug 09 23:07:58 2009'
  message_text = lines.drop(1).join()

  # Parse the message text into a Mail object instance
  msg = Mail.new(message_text)
  
  # Keep a histogram of senders
  # Fromatting each user in senders to be a tuple
  # senders["Matt"] = [1, 1, 1]
  # Where [0] = total number of emails
  #       [1] = number of threads started
  #       [2] = number of responses to others
  ###########################################
  from = msg.header['from'].to_s
  if senders.has_key? from
    senders[from] += 1
  else
    senders[from] = 1 
  end

  msg_count += 1
  if msg_count >= process_limit_num
    break
  end
end

puts "Total messages: #{msg_count} from #{senders.size} distinct authors"

senders.each do |x|
  puts x
end

exit
# Print out the senders and # of emails they sent, in ascending order
#puts senders.sort_by { |k,v| v }

column_names = senders.first
s=CSV.generate do |csv|
  csv << ["Sender, ", "Tally"]
  senders.each do |x|
    new_x = []
    if x[0]
      new_x[0] = x[0].sub('<', ', ').sub('>', '') # strip brackets in a safe way
      new_x[0].gsub! /"/, ''          # handle case where there are excess double quotes
    end 
    if x[1].class == String           # If x[1] exists and it's a string, then we can normalize on lowercase
      new_x[1] = x[1].downcase
    end
    csv << new_x
  end
end
File.write('the_file.csv', s)
