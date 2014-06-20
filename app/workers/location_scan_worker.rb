class LocationScanWorker
  include Sidekiq::Worker
  def perform(id)
    location = Location.find id
    location.scan
  end
end