Resque.redis = Redis.new(url: ENV["REDIS_URL"])

class BasicJsonFormatter
  ENQUEUED_REGEX = /got: \(Job\{([a-zA-Z0-9_]+)\} \| ([a-zA-Z0-9_]+) \| (.*)\)/
  EXECUTED_REGEX = /done: \(Job\{([a-zA-Z0-9_]+)\} \| ([a-zA-Z0-9_]+) \| (.*)\)/

  def call(severity, datetime, progname, msg)
    hash = {
      "severity" => severity,
      "datetime" => datetime
    }

    message_hash = _parse_msg(msg)
    hash.merge!(message_hash)

    hash["progname"] = progname unless progname.nil?

    "#{hash.to_json}\n"
  end

  private

  def _parse_msg(msg)
    enqueued_result = msg.match(ENQUEUED_REGEX)
    if enqueued_result
      return {
        "event" => "job_enqueued",
        "queue" => enqueued_result.captures[0],
        "job_name" => enqueued_result.captures[1],
        "payload" => _parse_payload(enqueued_result.captures[2])
      }
    end

    executed_result = msg.match(EXECUTED_REGEX)
    if executed_result
      return {
        "event" => "job_executed",
        "queue" => executed_result.captures[0],
        "job_name" => executed_result.captures[1],
        "payload" => _parse_payload(executed_result.captures[2])
      }
    end

    {
      "event" => "message",
      "msg" => msg
    }
  end

  def _parse_payload(payload)
    payload
  end
end

Resque.logger.level = Logger::INFO
Resque.logger = Logger.new($stdout)
Resque.logger.formatter = BasicJsonFormatter.new
