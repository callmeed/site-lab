class LocationScanWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(id)
    location = Location.find id
    location.scan
  end
end