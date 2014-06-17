json.array!(@technologies) do |technology|
  json.extract! technology, :id, :name, :search_regex
  json.url technology_url(technology, format: :json)
end
