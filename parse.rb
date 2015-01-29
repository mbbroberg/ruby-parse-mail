#!/usr/bin/env ruby

require 'mail'

to_parse = ARGV[0]
full_file = ""

File.open(to_parse).each(sep="\r") do |line|
    full_file << line
end

# puts "this is the file saved"
# puts "----------------------"
# puts full_file

mail = Mail.read_from_string(full_file)

puts mail.parts.length