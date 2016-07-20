require "abaci/version"

module Abaci
  autoload :Counter,      "abaci/counter"
  autoload :DateRange,    "abaci/date_range"
  autoload :Metric,       "abaci/metric"
  autoload :Store,        "abaci/store"

  # Configuration options
  class << self
    def [](key)
      Counter[key]
    end

    # Gets all specific metrics stored, without date-specific keys
    def metrics
      Metric.all
    end

    def options
      @options ||= {
        # the redis store to use for storage
        redis: nil,

        # a prefix to put before each key
        prefix: "stats",

        # the time zone to store date values in
        time_zone: "UTC",

        # separates metric keys from date parameters, change
        # this if you want to use it elsewhere in a key
        separator: "@"
      }
    end

    def prefix=(value)
      @store = nil
      options[:prefix] = value
    end

    def prefix
      options[:prefix]
    end

    def redis=(value)
      @store = nil
      options[:redis] = value
    end

    def store
      @store ||= Store.new(options)
    end
    alias_method :redis, :store

    def summary
      Counter.all
    end

    def time_zone
      options[:time_zone]
    end

    def time_zone=(value)
      options[:time_zone] = value
    end

    def method_missing(method, *args)
      Counter.send(method, *args)
    end
  end

  if defined?(Rails)
    require "abaci/railtie"
  end

  # Alias Stat to Abaci::Counter if nothing else is using the Stat namespace
  unless defined?(::Stat)
    ::Stat = Counter
  end
end
