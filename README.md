== README

This is my predecessor to the Ruby on Rails open source mail app "mailr."
The purpose of this app is to serve as a simple mail app for my website
as well as a point of reference to myself and others for simple tasks such
as creating users and using mongoid.

--Requirements:
Rails 4.0.0
Ruby 2.0.0
MongoDB - the most recent version should be fine

--Running(Assuming Linux):
$ cd location/of/mailr4
$ sudo service mongodb start
$ rails s
goto localhost:3000 in browser
$ sudo service mongodb stop

if you get the following error:
Could not connect to any secondary or primary nodes for replica set
<Moped::Cluster nodes=[<Moped::Node
resolved_address="127.0.0.1:27017">]>
run:
$ sudo rm /var/lib/mongodb/mongod.lock
$ mongod --repair
$ sudo service mongodb start


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
