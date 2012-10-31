module Abaci
  require 'redis'

  # Common interface for Redis. In the future this could be
  # swapped out for an alternate datastore.
  class Store
    def initialize(options)
      @redis = options[:redis] || Redis.current
      @prefix = options[:prefix] || 'abaci'
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

    def keys(pattern)
      sub = Regexp.new("^#{Abaci.prefix}:")
      exec(:keys, pattern).map { |k| k.gsub(sub, '') }
    end

    def set(key, value)
      exec(:set, key, value)
    end

    protected
      def exec(command, key, *args)
        if @redis and @redis.respond_to?(command)
          @redis.send(command, prefixed_key(key), *args)
        end
      end

      def prefixed_key(key)
        [ @prefix, key ].compact.join(':')
      end
  end
end