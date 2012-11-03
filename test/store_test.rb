require 'helper'

class StoreTest < Test::Unit::TestCase
  context "The abaci store" do
    should "use a prefix for storage" do
      Abaci.prefix = 'ab-test'
      assert_equal 'ab-test', Abaci.prefix

      assert_equal 0, Abaci['prefixes'].get

      assert_equal nil, REDIS.get("ab-test:prefixes")

      Abaci['prefixes'].increment
      assert_equal 1, Abaci['prefixes'].get

      assert_equal "1", REDIS.get("ab-test:prefixes")
    end

    should "be able to change the prefix" do
      Abaci.prefix = 'ab-test-too'

      assert_equal nil, REDIS.get("ab-test:prefixes")
      assert_equal nil, REDIS.get("ab-test-too:prefixes")

      Abaci.store.set 'prefixes', 1

      assert_equal nil, REDIS.get("ab-test:prefixes")
      assert_equal "1", REDIS.get("ab-test-too:prefixes")
    end

    should "list out all keys without prefixes" do
      now = Time.now

      Abaci['people'].increment

      expected_redis_keys = [
        'ab-test:people',
        "ab-test:people:#{now.strftime('%Y')}",
        "ab-test:people:#{now.strftime('%Y:%-m')}",
        "ab-test:people:#{now.strftime('%Y:%-m:%-d')}",
        "ab-test:people:#{now.strftime('%Y:%-m:%-d:%-k')}",
        "ab-test:people:#{now.strftime('%Y:%-m:%-d:%-k:%-M')}"
      ].sort

      assert_equal expected_redis_keys, REDIS.keys("ab-test:*").sort

      expected_abaci_keys = [
        'people',
        "people:#{now.strftime('%Y')}",
        "people:#{now.strftime('%Y:%-m')}",
        "people:#{now.strftime('%Y:%-m:%-d')}",
        "people:#{now.strftime('%Y:%-m:%-d:%-k')}",
        "people:#{now.strftime('%Y:%-m:%-d:%-k:%-M')}"
      ].sort

      assert_equal expected_abaci_keys, Abaci.store.keys.sort
    end

    should "be able to delete keys" do
      Abaci['ipods'].increment

      assert_equal 1, Abaci['ipods'].get

      Abaci.store.del('ipods')

      assert_equal 0, Abaci['ipods'].get
    end

    should "add list and remove items from a set" do
      Abaci.store.sadd('_metrics', 'people')
      Abaci.store.sadd('_metrics', 'places')
      Abaci.store.sadd('_metrics', 'things')

      assert_equal %w( people places things ).sort, Abaci.store.smembers('_metrics').sort

      Abaci.store.srem('_metrics', 'things')

      assert_equal %w( people places ).sort, Abaci.store.smembers('_metrics').sort
    end
  end
end