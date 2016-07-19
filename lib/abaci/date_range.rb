module Abaci
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
      start = (Date.today - Rational(seconds, 86400)).to_date
      new(start, Date.today)
    end

    def self.between(start, finish)
      new(start, finish)
    end

    def self.since(date)
      new(date, Date.today)
    end
  end
end
