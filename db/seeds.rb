# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

locations = Location.create([
  {name: 'Hacker News', url: 'http://news.ycombinator.com'},
  {name: 'Tech Crunch', url: 'http://www.techcrunch.com'}, 
  {name: 'BIG Folio', url: 'http://bigfolio.com'}
  ])

technologies = Technology.create([
  {name: 'WordPress', search_regex: "\/wp-content\/"},
  {name: 'Google Analytics', search_regex: "'UA[0-9-]+'"}
  ])