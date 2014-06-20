Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'sitelab' }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'sitelab' }
end
