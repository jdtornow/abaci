require "simplecov"
require "rspec"
require "abaci"
require "redis"
require "pry"
require "active_support"
require "active_support/core_ext"

REDIS = Redis.new(db: 10)

Abaci.redis = REDIS
Abaci.prefix = :abaci_tester

RSpec.configure do |config|

  config.mock_with :rspec
  config.expect_with :rspec

  config.before(:each) do
    REDIS.flushdb
  end

end
