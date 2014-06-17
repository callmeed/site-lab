class Location < ActiveRecord::Base
  has_and_belongs_to_many :technologies


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

end
