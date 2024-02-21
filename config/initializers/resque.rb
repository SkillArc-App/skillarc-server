Resque.redis = Redis.new(url: ENV.fetch("REDIS_URL", nil))

Resque.logger.level = Logger::INFO
Resque.logger = Logger.new($stdout)
Resque.logger.formatter = Logger::Formatter.new
