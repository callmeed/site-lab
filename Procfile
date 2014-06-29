web: bundle exec rails server -p $PORT
worker: bundle exec sidekiq -q high -q default -q low
search: elasticsearch -f -D es.config=/usr/local/opt/elasticsearch/config/elasticsearch.yml