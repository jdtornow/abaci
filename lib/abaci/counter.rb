module Abaci
  require "active_support/core_ext/time"

  class Counter
    attr_reader :key

    def initialize(key = nil)
      @key = key.to_s.downcase.strip
    end

    def decr(by = 1)
      decrement_at(nil, by)
    end
    alias_method :decrement, :decr

    def decrement_at(date = nil, by = 1)
      date = now unless date.respond_to?(:strftime)
      run(:decrby, by, date)
    end

    def del
      keys.each { |k| Abaci.store.del(k) }
      Metric.remove(key)
      true
    end

    def get(year = nil, month = nil, day = nil, hour = nil, min = nil)
      get_key = [ key, year, month, day, hour, min ].compact.join(":")
      Abaci.store.get(get_key).to_i
    end

    def get_date(date)
      get_key = date_in_time_zone(date).strftime("%Y:%-m:%-d")
      Abaci.store.get("#{ key }#{ Abaci.options[:separator] }#{ get_key }").to_i
    end

    def get_last_days(number_of_days = 30)
      dates = DateRange.ago(number_of_days).keys
      dates.map { |date| Abaci.store.get("#{ key }#{ Abaci.options[:separator] }#{ date }" ).to_i }.reduce(:+)
    end

    def incr(by = 1)
      increment_at(nil, by)
    end
    alias_method :increment, :incr

    def increment_at(date = nil, by = 1)
      date = now unless date.respond_to?(:strftime)
      Metric.add(key)
      run(:incrby, by, date)
    end

    def keys
      Abaci.store.keys("#{ key }*")
    end

    # Alias for Counter#new(key)
    def self.[](key)
      Counter.new(key)
    end

    # Returns a hash of all current values
    def self.all
      Metric.all.inject({}) { |hash, key| hash[key.to_sym] = Abaci.store.get(key).to_i; hash }
    end

    # Gets all currently logged stat keys
    def self.keys(search = "*")
      Abaci.store.keys(search).sort
    end

    def self.method_missing(method, *args)
      ms = method.to_s.downcase.strip

      if ms =~ /(incr|decr)(ement|ease)?_([a-z0-9_]*)$/
        return self[$3].send($1, *args)
      elsif ms =~ /^(clear|reset|del)_([a-z0-9_]*)!$/
        return self[$2].del
      elsif ms =~ /^last_(\d*)_days_of_([a-z0-9_]*)$/
        return self[$2].get_last_days($1)
      else
        self[ms].get(*args)
      end
    end

    private

    def run(method, by, date)
      time_segments = date_in_time_zone(date).strftime('%Y/%-m/%-d/%-k/%M').split("/").map(&:to_i)

      Abaci.store.send(method, key, by)

      time_segments.reduce([]) do |result, time|
        result.push(time)
        Abaci.store.send(method, "#{ key }#{ Abaci.options[:separator] }#{ result.join(":") }", by)
        result
      end
    end

    def date_in_time_zone(raw_date)
      raw_date.in_time_zone(Abaci.time_zone)
    end

    def now
      Time.now.in_time_zone(Abaci.time_zone)
    end

  end
end
