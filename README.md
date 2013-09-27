This is my successor to the Ruby on Rails, open source mail app, "mailr."

https://github.com/lmanolov/mailr

The purpose of this app is to serve as a simple mail app, as well as a point of reference for myself and others for simple tasks such as creating a user database with mongoid.

--Release

  * Currently in production. However, the most recent github version should be runnable.

--Requirements:

  * Rails 4.0.0

  * Ruby 2.0.0

  * MongoDB >= 2.4.6

--Running from command line (Linux):

  <tt>$ cd location/of/mailr4</tt>

  <tt>$ sudo service mongodb start</tt>

  <tt>$ rails s</tt>

  <tt>$ #goto localhost:3000 in browser</tt>

  <tt>$ sudo service mongodb stop</tt>

--Error: Could not connect to any secondary or primary nodes
  for replica set <Moped::Cluster nodes=[<Moped::Node resolved_address="127.0.0.1:27017">
  , run:

  <tt>$ sudo rm /var/lib/mongodb/mongod.lock</tt>

  <tt>$ mongod --repair</tt>

  <tt>$ sudo service mongodb start</tt>

