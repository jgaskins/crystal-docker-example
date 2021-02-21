require "redis"

REDIS = Redis::Client.from_env("REDIS_URL")
