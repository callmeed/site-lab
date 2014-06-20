class Technology < ActiveRecord::Base
  has_and_belongs_to_many :locations


  def regex 
    return /#{self.search_regex}/
  end

  def self.update_counter_cache
    all.each do |technology|
      technology.update_attribute(:locations_count, technology.locations.count)
    end
  end
end
