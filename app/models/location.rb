class Location < ActiveRecord::Base
  has_and_belongs_to_many :technologies

  attr_accessor :skip_scan

  after_create :scan 

  def self.uncached
    # Find locations that have no cached source
    # We assume these had problems fetching
    where('cached_source IS NULL').order('created_at DESC')
  end

  def emails(use_cache = true)
    return [] if self.cached_source.blank?
    emails = []
    self.cached_source.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) do |x| 
      emails << x
    end
    return emails.uniq
  end

  def cached_body_text
    # Takes the cached source and 
    # extracts the text from the <body> with tags and JS removed
    body_source = Nokogiri::HTML(cached_source.gsub(/<script[^<]+<\/script>/m,'')).css('body').text
    body_text = Sanitize.fragment(body_source, Sanitize::Config::RELAXED).squish
  end

  def fetch_body(location = nil)
    # This fetches the source/body of the location
    # It's recursive and will follow the location in the
    # event of a 301 or other redirect
    
    location ||= self.url

    uri = URI(location) 
    if uri.port == 443
      # Ran into some ssl sites with bad certs, so we'll bypass
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.get(uri.request_uri)
    else
      response = Net::HTTP.get_response(uri)
    end
    
    case response
    when Net::HTTPSuccess   
      body = response.body.force_encoding('iso-8859-1').encode('utf-8')
      self.update_attribute(:cached_source, body)
      return body
    when Net::HTTPRedirection 
      self.update_attribute(:url, response['location'])
      fetch_body(response['location'])
    end
  end

  def headers
    response = Net::HTTP.get_response(URI.parse(self.url))
    return response.header.to_hash
  end

  def scan
    # Skip scanning if set (this is for batch imports)
    return if self.skip_scan
    # Fetch the body, get all technologies and scan
    body = self.fetch_body
    tech = Technology.all
    tech.each do |t|
      if t.regex =~ body 
        # There's a match, add it unless it's already there
        self.technologies << t unless self.technologies.include? t
      else
        # No match, make sure to delete if it's there (maybe they removed it)
        self.technologies.delete(t) if self.technologies.include? t
      end
    end
  end

end
