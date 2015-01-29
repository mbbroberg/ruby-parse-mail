#!/usr/bin/env ruby

require 'mail'

to_parse = ARGV[0]

File.open(to_parse).each(sep="\r") do |line|
    puts line
end