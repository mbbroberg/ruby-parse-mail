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
  puts "You can also output to CSV with --format=csv."
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

  # Step 1:
  # msg.to 
  # msg.from
  # Parse them for Basho or not
  #   >> mail.from[0].split("@")
  #   => ["tarvid", "ls.net"]
  email = msg.from[0]
  id = email.split("@")[0] ## First value will be the unique identifier of each user
  domain = email.split("@")[1]

  # Step 2: 
  # if the msg.subject is `ss:` it covers RE: and SV: and is a reply
  

  # Step 3:
  # Tally a histogram of senders
  if senders.has_key? id
    # If we've seen this before, pop the value out for updates
    puts "ID is #{id}"
    puts email
    puts senders[id]
    id_profile = senders[id]
    id_profile[:sent] += 1
    senders[id] = id_profile
  else
    # build a profile for the first time
    id_profile = {:asked => 0, :answered => 0, :sent => 1, :email => email, :domain => domain}
    senders[id] = id_profile
  end



  # Step 4: 
  # Keep a tally total of messages 
  msg_count += 1

  ## For testing 
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
    csv << ["Sender", "Domain", "Asked", "Answered", "Sent", "Total Messages", "Total Senders"] # Name the columns
    csv << ["","","","","", msg_count, senders.size]
    senders.each do |x|
      id = x[0]
      id_profile = senders[id]
      clean_email = []
      if email=id_profile[:email]
        clean_email = email.sub('<', ', ').sub('>', '') # strip brackets in a safe way
        clean_email.gsub!(/"/, '')
      end
      # if x[1].class == String
      #   clean_email[1] = x[1].downcase                  # If x[1] exists and it's a string, then we can normalize to down
      # end
      csv << [clean_email, id_profile[:domain], id_profile[:asked], id_profile[:answered], id_profile[:sent]]
    end
  end
  File.write('the_file.csv', s)
end