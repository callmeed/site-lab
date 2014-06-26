class TechnologyScanWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(id)
    tech = Technology.find id
    tech.scan_locations
  end
end