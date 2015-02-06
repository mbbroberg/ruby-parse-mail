#!/usr/bin/env ruby

require 'mail'

message = nil
count = 0

def parse_message(message)
  mail = Mail.new(message)

  puts mail.from
  puts mail.subject
  puts mail.message_id
  #do_other_stuff!
end


while (line = STDIN.gets)
  if (line.match(/\AFrom /))
    parse_message(message) if (message)
    #print message
    message = ''
    count += 1
  else
    message << line.sub(/^\>From/, 'From')
  end
end

puts "the count is #{count}"

