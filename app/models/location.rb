class Location < ActiveRecord::Base
  has_and_belongs_to_many :technologies

  after_create :scan 

  def fetch_body(location = nil)
    # This fetches the source/body of the location
    # It's recursive and will follow the location in the
    # event of a 301 or other redirect
    
    location ||= self.url

    response = Net::HTTP.get_response(URI.parse(location))
    
    case response
    when Net::HTTPSuccess   
      body = response.body
      self.update_attribute(:cached_source, body)
      return body
    when Net::HTTPRedirection 
      self.update_attribute(:url, response['location'])
      fetch_body(response['location'])
    end
  end

  def scan
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
