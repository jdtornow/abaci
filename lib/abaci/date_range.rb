module Abaci
  require "active_support/core_ext/time"

  class DateRange

    attr_reader :start, :finish

    def initialize(start, finish)
      if start < finish
        @start = start
        @finish = finish
      else
        @start = finish
        @finish = start
      end
    end

    def days
      range.to_a
    end

    def keys
      days.map { |d| d.strftime("%Y:%-m:%-d") }
    end

    def range
      start..finish
    end

    def self.ago(days = 30)
      seconds = days.to_i * 86400
      start = (now.to_date - Rational(seconds, 86400)).to_date
      new(start, now.to_date)
    end

    def self.between(start, finish)
      new(start, finish)
    end

    def self.now
      Time.now.in_time_zone(Abaci.time_zone)
    end

    def self.since(date)
      new(date, now.to_date)
    end

  end
end
