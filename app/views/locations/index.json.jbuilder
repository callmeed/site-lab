json.array!(@locations) do |location|
  json.extract! location, :id, :name, :url, :cached_results
  json.url location_url(location, format: :json)
end
