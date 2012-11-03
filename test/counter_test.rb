require 'helper'

class CounterTest < Test::Unit::TestCase
  context "A counter" do
    should "increment a stat" do
      assert_equal 0, Abaci['testers'].get

      Abaci['testers'].increment

      assert_equal 1, Abaci['testers'].get

      Abaci['testers'].increment(2)

      assert_equal 3, Abaci['testers'].get
    end

    should "decrement a stat" do
      assert_equal 0, Abaci['testers'].get

      Abaci['testers'].increment(5)
      assert_equal 5, Abaci['testers'].get

      Abaci['testers'].decrement
      assert_equal 4, Abaci['testers'].get

      Abaci['testers'].decrement(2)
      assert_equal 2, Abaci['testers'].get
    end

    should "increment a stat down to the minute" do
      now = Time.now

      Abaci['people'].increment

      expected_keys = [
        'people',
        "people:#{now.strftime('%Y')}",
        "people:#{now.strftime('%Y:%-m')}",
        "people:#{now.strftime('%Y:%-m:%-d')}",
        "people:#{now.strftime('%Y:%-m:%-d:%-k')}",
        "people:#{now.strftime('%Y:%-m:%-d:%-k:%-M')}"
      ].sort

      assert_equal expected_keys, Abaci['people'].keys.sort

      assert_equal 1, Abaci['people'].get
      assert_equal 1, Abaci['people'].get(now.year)
      assert_equal 1, Abaci['people'].get(now.year, now.month)
      assert_equal 1, Abaci['people'].get(now.year, now.month, now.day)
      assert_equal 1, Abaci['people'].get(now.year, now.month, now.day, now.hour)
      assert_equal 1, Abaci['people'].get(now.year, now.month, now.day, now.hour, now.min)
    end

    should "increment a stat at a certain date" do
      time = Time.new(2012, 2, 29, 23, 29)

      Abaci['people'].increment_at(time)

      expected_keys = [
        'people',
        "people:2012",
        "people:2012:2",
        "people:2012:2:29",
        "people:2012:2:29:23",
        "people:2012:2:29:23:29"
      ].sort

      assert_equal expected_keys, Abaci['people'].keys.sort

      assert_equal 1, Abaci['people'].get
      assert_equal 1, Abaci['people'].get(2012)
      assert_equal 1, Abaci['people'].get(2012, 2)
      assert_equal 1, Abaci['people'].get(2012, 2, 29)
      assert_equal 1, Abaci['people'].get(2012, 2, 29, 23)
      assert_equal 1, Abaci['people'].get(2012, 2, 29, 23, 29)
    end

    should "get stats summary for last 5 days" do
      time = Time.new(2012, 5, 30, 5, 0)
      time2 = Time.new(2012, 5, 31, 5, 0)
      time3 = Time.new(2012, 6, 1, 5, 0)
      time4 = Time.new(2012, 6, 2, 5, 0)

      Abaci['people'].increment_at(time)
      Abaci['people'].increment_at(time2)
      Abaci['people'].increment_at(time3)
      Abaci['people'].increment_at(time4)
      Abaci['people'].increment

      Date.stubs(:today).returns(Date.new(2012, 6, 2))

      assert_equal 5, Abaci['people'].get
      assert_equal 4, Abaci['people'].get_last_days(30)
      assert_equal 3, Abaci['people'].get_last_days(2)
      assert_equal 2, Abaci['people'].get_last_days(1)

      Date.unstub(:today)
    end

    should "delete stats for a given key" do
      time = Time.new(2012, 2, 29, 23, 29)

      Abaci['people'].increment_at(time)

      expected_keys = [
        'people',
        "people:2012",
        "people:2012:2",
        "people:2012:2:29",
        "people:2012:2:29:23",
        "people:2012:2:29:23:29"
      ].sort

      assert_equal expected_keys, Abaci['people'].keys.sort

      Abaci['people'].del

      assert_equal [], Abaci['people'].keys
    end

    should "return all stat keys across all metrics" do
      time = Time.new(2012, 2, 29, 23, 29)

      Abaci['people'].increment_at(time)
      Abaci['places'].increment_at(time)
      Abaci['things'].increment_at(time)

      expected_keys = [
        'people',
        "people:2012",
        "people:2012:2",
        "people:2012:2:29",
        "people:2012:2:29:23",
        "people:2012:2:29:23:29",
        'places',
        "places:2012",
        "places:2012:2",
        "places:2012:2:29",
        "places:2012:2:29:23",
        "places:2012:2:29:23:29",
        'things',
        "things:2012",
        "things:2012:2",
        "things:2012:2:29",
        "things:2012:2:29:23",
        "things:2012:2:29:23:29"
      ].sort

      assert_equal expected_keys, Abaci.keys.sort
    end

    should "return all metrics stores, without date-specific keys" do
      time = Time.new(2012, 2, 29, 23, 29)

      Abaci['people'].increment_at(time)
      Abaci['places'].increment_at(time)
      Abaci['things'].increment_at(time)

      expected_keys = %w( people places things ).sort

      assert_equal expected_keys, Abaci.metrics.sort
    end

    should "return a hash of all top-level metrics and current values" do
      Abaci['people'].increment
      Abaci['places'].increment
      Abaci['things'].increment(2)

      expected_result = {
        :people => 1,
        :places => 1,
        :things => 2
      }

      assert_equal expected_result, Abaci.summary
    end

    should "have handy shortcuts for incrementing simple metrics" do
      Abaci.increment_people
      Abaci.increment_places(2)
      Abaci.increase_things
      Abaci.incr_people

      assert_equal 2, Abaci.people
      assert_equal 2, Abaci.places
      assert_equal 1, Abaci.things

      Abaci.decrease_things

      assert_equal 0, Abaci.things

      Abaci.clear_people!

      assert_equal 0, Abaci.people

      assert_equal 2, Abaci.last_20_days_of_places
    end
  end
end