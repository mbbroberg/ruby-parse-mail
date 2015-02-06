#!/usr/bin/env ruby

require 'mail'

message = ''
count = 0

def parse_message(message)
  mail = Mail.new(message)

  #do_other_stuff!
end


while (line = STDIN.gets)
  if (line.match(/\AFrom /))
    parse_message(message) if (message)
    message = ''
    count += 1
  else
    message << line.sub(/^\>From/, 'From')
  end
end

puts "the count is #{count}"
