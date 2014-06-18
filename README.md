Site Lab
=====

Site Lab aims to be an open-source replacement for website analysis tools such as BuiltWith, NerdyData, and DataNyze. 

Site Lab is a Ruby on Rails application. It uses PostgreSQL as its database and Redis + Sidekiq for background processing. 

How Does it Work? 
-----

Right now, it's fairly simple: 

- The [MetaInspector Gem](https://github.com/jaimeiniesta/metainspector) retrieves some basic info about the site/URL
- There is a "Technology" model which stores regular expressions
- Technologies are matched against the source of the sites/URLs

More complex analysis is in the works. 

Installation
-----

It's a Rails 4.1 app, so you'll need a dev environment that supports that (prolly RVM). 

- Clone the repo
- Edit the database.yml file with your info
- Run `bundle install` to install gems
- Run `bundle exec rake db:create` to create the DB(s)
- Run `bundle exec rake db:seed` to load the seed data
- Run `rails s` to start the server locally

Screenshot
-----

![Screenshot](https://raw.githubusercontent.com/callmeed/site-lab/master/screen.png)