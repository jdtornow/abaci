require 'helper'

class DateRangeTest < Test::Unit::TestCase
  context "The date range calculator" do
    should "get a day X days in the past" do
      time = Date.new(2012, 11, 6)
      expected_time = Date.new(2012, 11, 1)

      Date.stubs(:today).returns(time)

      assert_equal expected_time, Abaci::DateRange.ago(5).start

      Date.unstub(:today)
    end

    should "get days since a given date" do
      time = Date.new(2012, 11, 6)
      expected_time = Date.new(2012, 11, 1)

      Date.stubs(:today).returns(time)

      since = Abaci::DateRange.since(expected_time)

      assert_equal expected_time, since.start
      assert_equal time, since.finish

      Date.unstub(:today)
    end

    should "get days between a given date range" do
      day1 = Date.new(2012, 11, 1)
      day2 = Date.new(2012, 11, 6)

      range = Abaci::DateRange.between(day1, day2)

      assert_equal day1, range.start
      assert_equal day2, range.finish
    end

    should "make days are in order" do
      day1 = Date.new(2012, 11, 1)
      day2 = Date.new(2012, 11, 6)

      range = Abaci::DateRange.between(day2, day1)

      assert_equal day1, range.start
      assert_equal day2, range.finish
    end

    should "have a range of days" do
      day1 = Date.new(2012, 11, 1)
      day2 = Date.new(2012, 11, 6)

      range = Abaci::DateRange.between(day2, day1)

      assert_equal (day1..day2), range.range
    end

    should "have an array of days" do
      day1 = Date.new(2012, 11, 1)
      day2 = Date.new(2012, 11, 6)

      range = Abaci::DateRange.between(day2, day1)

      expected_result = [
        Date.new(2012, 11, 1),
        Date.new(2012, 11, 2),
        Date.new(2012, 11, 3),
        Date.new(2012, 11, 4),
        Date.new(2012, 11, 5),
        Date.new(2012, 11, 6)
      ]

      assert_equal expected_result, range.days
    end

    should "have a list of store keys for a range" do
      day1 = Date.new(2012, 11, 1)
      day2 = Date.new(2012, 11, 6)

      range = Abaci::DateRange.between(day2, day1)

      expected_result = [
        '2012:11:1',
        '2012:11:2',
        '2012:11:3',
        '2012:11:4',
        '2012:11:5',
        '2012:11:6'
      ]

      assert_equal expected_result, range.keys
    end
  end
end