# Ruby Mail Parser

A simple way to review mailing list emails that are in mbox format.

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

## Usage

The current versions are in an early development mode. 

#### parse_mbox.rb

You can run it by running: 

     ./parse_mbox.rb sample.mbox

^ This works well :shipit:

#### parse.rb 

You can run it by calling `parse.rb` after you read a file: 

     cat sample.mbox | ruby parse.rb

This approach may not be practical going forward and we could look into using the `mail` library to read directly from an mbox file.
     
## Versioning

I'd like to add some meaningful tags as milestones are met. They are: 

1. Version `0.1` is able to calculate the **number of orphaned threads**
1. Version `0.2` is able to identify **unanswered threads**
1. Version `0.3` is able to identify what threads **from current customers** and active prospects

#### Some Definitions

* **Orphaned**: No one but the original sender has replied to thread 
* **Unanswered**: Originator last to respond (and possibly more text searching for question marks)
* **Customer/Prospect**: TBD - some correlation with Salesforce and Zendesk data

## Contributors
Public contribution is great. We'll make an effort to define them better once this works :+1:. For now, add a shout out below: 

* Originally by [Matthew Brender](https://github.com/mjbrender)
* Contribution by [Rob Nelson](https://github.com/rnelson0)
* Great ruby help by [Dmitri Zagidulin](https://github.com/dmitrizagidulin) 
* __________________ << You're next