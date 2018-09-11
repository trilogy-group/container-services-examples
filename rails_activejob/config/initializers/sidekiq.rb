# redis_config = YAML.load_file(Rails.root + 'config/redis.yml')[Rails.env]
redis_config = {
  'host' => ENV.fetch("REDIS_HOST") { "localhost" },
  'port' => ENV.fetch("REDIS_PORT") { 6379 },
}

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{redis_config['host']}:#{redis_config['port']}"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{redis_config['host']}:#{redis_config['port']}"
  }
end
