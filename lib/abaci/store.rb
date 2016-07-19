module Abaci
  require "redis"

  # Common interface for Redis. In the future this could be
  # swapped out for an alternate datastore.
  class Store
    attr_reader :prefix, :redis

    def initialize(options)
      @redis = options[:redis] || Redis.current
      @prefix = options[:prefix] || "stats"
    end

    def decrby(key, by = 1)
      exec(:decrby, key, by)
    end

    def del(key)
      exec(:del, key)
    end

    def get(key)
      exec(:get, key)
    end

    def incrby(key, by = 1)
      exec(:incrby, key, by)
    end

    def keys(pattern = "*")
      sub = Regexp.new("^#{ prefix }:")
      exec(:keys, pattern).map { |k| k.gsub(sub, "") }
    end

    def set(key, value)
      exec(:set, key, value)
    end

    def sadd(key, member)
      exec_without_prefix(:sadd, "#{ prefix }-#{ key }", member)
    end

    def smembers(key)
      exec_without_prefix(:smembers, "#{ prefix }-#{ key }")
    end

    def srem(key, member)
      exec_without_prefix(:srem, "#{ prefix }-#{ key }", member)
    end

    private

    def exec(command, key, *args)
      if @redis and @redis.respond_to?(command)
        @redis.send(command, prefixed_key(key), *args)
      end
    end

    def exec_without_prefix(command, key, *args)
      if @redis and @redis.respond_to?(command)
        @redis.send(command, key, *args)
      end
    end

    def prefixed_key(key)
      [ prefix, key ].compact.join(":")
    end

  end
end
