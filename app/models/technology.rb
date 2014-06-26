class Technology < ActiveRecord::Base
  has_and_belongs_to_many :locations

  after_commit :queue_scan, on: :create

  def regex 
    return /#{self.search_regex}/
  end

  def queue_scan
    TechnologyScanWorker.perform_async(self.id)
  end

  def penetration_rate
    return ((self.locations_count.to_f / Location.count.to_f) * 100.0).round(1)
  end

  def scan_locations(use_cache = true)
    locations = Location.where('cached_source IS NOT NULL')
    locations.each do |location| 
      if self.regex =~ location.cached_source
        # There's a match, add it unless it's already there
        self.locations << location unless self.locations.include? location
      else
        # No match, make sure to delete if it's there (maybe they removed it)
        self.locations.delete(location) if self.locations.include? location
      end
    end
    selt.update_attribute(:locations_count, self.locations.count)
  end

  def self.update_counter_cache
    all.each do |technology|
      technology.update_attribute(:locations_count, technology.locations.count)
    end
  end
end
