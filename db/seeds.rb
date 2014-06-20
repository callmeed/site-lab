# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Technology.count == 0
  technologies = Technology.create([
    {name: 'WordPress', search_regex: "\/wp-content\/"},
    {name: 'Google Analytics', search_regex: "'UA[0-9-]+'"},
    {name: 'Kissmetrics', search_regex: "i\.kissmetrics\.com\/i\.js"},
    {name: 'Mixpanel', search_regex: "mixpanel\.init"}, 
    {name: 'Hello Bar', search_regex: "hellobar\.com\/hellobar\.js"},
    {name: 'Optimizely', search_regex: "\/\/cdn\.optimizely\.com"}, 
    {name: 'jQuery (Google CDN)', search_regex: "\/\/ajax\.googleapis\.com\/ajax\/libs\/jquery\/"}, 
    {name: 'Google AdWords Conversion Tracking', search_regex: "googleadservices\.com\/pagead\/conversion\.js"},
    {name: 'Twitter Widgets', search_regex: "\/\/platform\.twitter\.com\/widgets\.js"}, 
    {name: 'AdRoll', search_regex: "function\s+setAdroll\(\)"}
    ])
end

if Location.count == 0
  locations = Location.create([
    {name: 'Hacker News', url: 'http://news.ycombinator.com'},
    {name: 'Tech Crunch', url: 'http://www.techcrunch.com'}, 
    {name: 'ModCloth', url: 'http://www.modcloth.com/'}, 
    {name: 'Skull Candy', url: 'http://www.skullcandy.com/'},
    {name: 'Buzz Feed', url: 'http://www.buzzfeed.com/'},
    {name: 'Engadget', url: 'http://www.engadget.com/'}, 
    {name: 'Huffington Post', url: 'http://www.huffingtonpost.com/'}, 
    {name: 'Tennis Warehouse', url: 'http://www.tennis-warehouse.com/'}, 
    {name: 'Fab', url: 'http://fab.com/'}
    ])
end 