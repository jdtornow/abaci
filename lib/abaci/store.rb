module Abaci
  require 'redis'

  # Common interface for Redis. In the future this could be
  # swapped out for an alternate datastore.
  class Store
    def initialize(options)
      @redis = options[:redis] || Redis.current
      @prefix = options[:prefix] || 'abaci'
    end

    def get(key)
      exec(:get, prefixed_key(key))
    end

    def set(key, value)
      exec(:set, prefixed_key(key), value)
    end

    protected
      def exec(command, *args)
        if @redis and @redis.respond_to?(command)
          @redis.send(command, *args)
        end
      end

      def prefixed_key(key)
        [ @prefix, key ].compact.join(':')
      end
  end
end