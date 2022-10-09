# frozen_string_literal: true

# Manager class for redis
class RedisManager
  attr_reader :db

  def initialize(db = 0)
    @db = Redis.new(url: "#{ENV['REDIS_URL']}#{db}")
  end

  def get(key)
    stored_value = db.get(key)
    JSON.parse(stored_value) if stored_value.present?
  end

  def set_with_ttl(key, value, ttl = 30.minutes)
    db.setex(key, ttl.seconds.to_i, value.to_json)
  end
end
