class RuleState
  KEY_FMT = "rule_state:%{rule_id}:%{car}".freeze
  attr_reader :rule_id, :car_code, :data

  def initialize(rule_id, car_code)
    @rule_id  = rule_id
    @car_code = car_code
    @key      = format(KEY_FMT, rule_id:, car: car_code)
    @redis    = Redis.new(url: ENV.fetch("REDIS_URL", "redis://redis:6379/0"))
    @data     = @redis.hgetall(@key).symbolize_keys
  end

  def open?(now = Time.now)
    data[:state] == "open"
  end

  def seconds_since_open(now = Time.now)
    open? ? now.to_f - data[:opened_at].to_f : 0
  end

  def seconds_since_sent(now = Time.now)
    now.to_f - data[:last_sent_at].to_f
  end

  def mark_open(now, value)
    @redis.hmset(@key,
                 :state,         "open",
                 :opened_at,     now.to_f,
                 :last_sent_at,  now.to_f,
                 :last_value,    value)
    @redis.expire(@key, 86_400)            # 24 h – wystarczy
  end

  def mark_refresh(now, value)
    @redis.hmset(@key,
                 :last_sent_at, now.to_f,
                 :last_value,   value)
  end

  def mark_closed
    @redis.del(@key)
  end
end
