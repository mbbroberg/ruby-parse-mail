#### How to scrape for files as a user 
# wget -r -l1 -H -t1 -nd -N -np -A.mp3 -erobots=off [url of website]
# http://lists.basho.com/pipermail/riak-users_lists.basho.com/

##### How I get it as an admin
# wget --save-cookies cookies.txt --post-data "user=USER&password=PASSWORD" http://lists.basho.com/mailman/private/riak-users_lists.basho.com.mbox/riak-users_lists.basho.com.mbox