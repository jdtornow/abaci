# SimpleCov provides test coverage in ruby 1.9 environments only, fail silently
# if it is not available
begin; require 'simplecov'; rescue LoadError; end

require 'shoulda'
require 'test/unit'
require 'mocha'
require 'redis'
require 'abaci'

# Fail silently if Turn is not available (runs in 1.9+ only)
begin; require 'turn/autorun'; rescue LoadError; end

REDIS = Redis.new(:db => 1)

Abaci.redis = REDIS

class Test::Unit::TestCase
  def setup
    REDIS.flushdb
    Abaci.prefix = 'ab-test'
  end
end