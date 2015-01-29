#!/usr/bin/env ruby

require 'mail'

# Process input file -- singular for now
to_parse = ARGV[0]
full_file = ""

File.open(to_parse).each(sep="\r") do |line|
    full_file << line

#### Adding parsing logic manually until I figure out what Mail can do on it's own ####
    some_meaningful_variable = line ###### First part of line?
    case some_meaningful_variable
    ####### Note that the first line starts with From without the ":" and will get confusing if you use it too
    when "From:"
        # From: blah at blah.com (Nickname)
        # you have the user's email address here in a weird format
        puts
    when "Date:"
        # Date: Thu, 22 Jan 2015 17:59:31 -0500
        puts
    when "Subject:"
        # Subject: Hello, everybody...
        # note: replies have the same subject
        #       and follow with additional line called
        #       "In-Reply-To:" with a hash of the email
        ###################
        puts
    end
    ## End case 
end

# puts "this is the file saved"
# puts "----------------------"
# puts full_file

mail = Mail.read_from_string(full_file)

user_hash = {}
