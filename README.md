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
- Much of the processing now happens in the background (via [Sidekiq](http://sidekiq.org/))

More complex analysis is in the works. 

Installation
-----

It's a Rails 4.1 app, so you'll need a dev environment that supports that (prolly RVM). You'll also need Redis installed and running (probably via Homebrew)

- Clone the repo
- Edit the database.yml file with your info
- Run `bundle install` to install gems
- Run `bundle exec rake db:create` to create the DB(s)
- Run `bundle exec rake db:seed` to load the seed data
- Run `foreman start -p 3000` to start the rails server & sidekiq locally on port 3000

Importing Data
-----

While you can surely add sites/URLs one-by-one in the app, most use-cases will involve importing large sets of URLs from files or external sites. With that in mind, I've started a set of Rake tasks for importing URLs. Currently, it includes: 

- Importing all startups from AngelList for a given market 
- Importing all startup/product URLs listed on http://www.producthunt.com 
- Importing URLs from a text file (placed in app/import)

Run a `rake -T` to see the tasks and required parameters

Screenshot
-----

![Screenshot](https://raw.githubusercontent.com/callmeed/site-lab/master/screen.png)