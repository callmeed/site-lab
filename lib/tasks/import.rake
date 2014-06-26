require 'rubygems'
require 'json'
require 'net/http'
require 'nokogiri'

namespace :import do
  desc "Imports all the links from ProductHunt" 
  task producthunt: :environment do 
    body = open('http://www.producthunt.com/').read
    doc = Nokogiri::HTML.parse(body)
    links = doc.css('a.post-url')
    puts "Found #{links.size} links on ProductHunt ..."
    links.each do |link|
      url = "http://www.producthunt.com" + link['href']
      location = Location.where(name: link.text).first_or_initialize
      if location.new_record? 
        puts "Importing #{link.text} (#{url})"
        location.url = url
        location.skip_scan = true
        location.save
        LocationScanWorker.perform_async(location.id)
      end
    end
  end

  desc "Imports sites from VCDelta"
  task vcdelta: :environment do 
    body = open('http://neuvc.com/labs/vcdelta/').read
    doc = Nokogiri::HTML.parse(body)
    links = doc.xpath('//table/tbody/tr/td[3]/a')
    puts "Found #{links.size} links on VCDelta ..."
    links.each do |link|
      url = link['href'] + '/'
      location = Location.where(url: url).first_or_initialize
      if location.new_record? 
        puts "Importing #{link.text} (#{url})"
        location.name = link.text
        location.skip_scan = true
        location.save
        LocationScanWorker.perform_async(location.id)
      end
    end
  end

  desc "Imports list of URLs from a file"
  task :file, [:filename] => :environment do |t, args|
    args.with_defaults(filename: "test.txt")
    puts "Importing file #{args.filename}"
    text = File.open(File.join(Rails.root, 'app/import', args.filename)).read
    text.each_line do |line|
      url = line.chomp
      name = url.gsub(/^http:\/\//i, '').gsub(/\/$/i,'')
      puts "Importing #{name} ..."
      location = Location.where(url: url).first_or_initialize
      if location.new_record? 
        location.name = name
        location.skip_scan = true
        location.save
        LocationScanWorker.perform_async(location.id)
      end
    end
  end

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
          LocationScanWorker.perform_async(location.id)
        end
      end
    end
  end
end
