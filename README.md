# Ruby Parser

A simple, messy way to review mailing list emails that are compressed into single files.

## Goal

I'd like to build something useful to Developer Advocates who need to keep track of the conversation in mailing lists. The details will shift with time I'm sure, but the initial thought is: 

* Download and get files into a parseable state
* Parse files into a spreadsheet-able format

By **parsing** I mean: 

* Identify number of emails per day
* Identify number of unique participants
* Identify whether an email is a new thread or response to existing thread
* Determine whether thread resolves issue (if that's possible)

Other questions I'd like to have data to answer: 

* Top contributors
* Most questions asked 
* Most questions answered 
* Number of "active" members 
* % of active members by domain (i.e. Basho or otherwise)

Other goals I'd like to achieve: 

* Achieve [idempotence](http://en.wikipedia.org/wiki/Idempotence) so that the script can run dozens of times and print out something like Ansible playbooks do
* Make something pretty a la [omglog](https://github.com/benhoskings/omglog) visualization of threads
* Make a calendar view of contributions


