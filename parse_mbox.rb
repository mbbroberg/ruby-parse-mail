#!/usr/bin/env ruby

# Usage: ./parse_mbox.rb mailing_list.mbox
# The input file should be in Mbox http://www.qmail.org/man/man5/mbox.html format

# For Mailman/pipermail type mailing lists, you can retrieve them (if you're a list member) at:
# http://www.example.com/mailman/private/<listname>.mbox/<listname>.mbox

require 'mail'

file_name = ARGV[0]
senders = {}
msg_count = 0
process_limit_num = 100  # Only parse the first N messages

puts "Parsing #{file_name}..."

File.open(file_name,"r:iso-8859-2").slice_before(/^From /).each do | lines |
  # Drop the first line since it's the mbox-specific 'From ...@... Sun Aug 09 23:07:58 2009'
  message_text = lines.drop(1).join()

  # Parse the message text into a Mail object instance
  msg = Mail.new(message_text)
  
  # Keep a histogram of senders
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

# Print out the senders and # of emails they sent, in ascending order
puts senders.sort_by { |k,v| v }