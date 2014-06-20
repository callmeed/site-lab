require 'rubygems'
require 'json'
require 'net/http'

namespace :import do
  desc "Imports all startups from AngelList for a given tag"
  task :angellist, [:tag] => :environment do |t, args|
    args.with_defaults(tag: "wearables-2")
    puts "Hello you searched for tag #{args.tag}"
    # First we have to get the tag ID for the slug
    url = "https://api.angel.co/1/search/slugs?query=#{args.tag}"
    response = Net::HTTP.get_response(URI.parse(url))
    body = response.body
    data = JSON.parse(body)
    tag_id = data['id']
    tag_name = data['name']
    puts "The #{tag_name} has ID #{tag_id}"
    # Now page through all the startups
    # First get the count/pages
    url = "https://api.angel.co/1/tags/#{tag_id}/startups?order=popularity"
    response = Net::HTTP.get_response(URI.parse(url))
    body = response.body
    data = JSON.parse(body)
    last_page = data['last_page']
    startup_count = data['total']
    puts "There are #{startup_count} startups and #{last_page} pages"
    # Loop through the pages
    for i in 1..last_page do 
      url = "https://api.angel.co/1/tags/#{tag_id}/startups?order=popularity&page=#{i}"
      response = Net::HTTP.get_response(URI.parse(url))
      body = response.body
      data = JSON.parse(body)
      startups = data['startups']
      puts "Found #{startups.size} startups on page #{i} ... "
      # Loop through the startups
      data['startups'].each do |startup|
        next if startup['company_url'].blank? 
        puts "Importing #{startup['name']}"
        url = startup['company_url'] + '/'
        location = Location.where(url: url).first_or_initialize
        if location.new_record? 
          location.name = startup['name']
          location.skip_scan = true
          location.save
        end
      end
    end
  end
end
