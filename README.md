# Abaci

[![Build Status](https://travis-ci.org/jdtornow/abaci.svg?branch=master)](http://travis-ci.org/jdtornow/abaci)

Abaci (pronounced abba-sigh) is a simple structure for the collection and reporting on numerical counters. Counters can be used to track time-based statistics for a wide array of functions within your application. Abaci uses a Redis backend to store all counters for lightning quick read and write access.

What does *abaci* mean? Its the plural form of [Abacus](http://en.wikipedia.org/wiki/Abacus), a common arithmetic assistance device from before we had computers. Imagine that.

## Requirements

* Ruby 2.2+
* Redis

## Configuration

Abaci will use the default Redis instance by default, assumed to be available via `Redis.current`. To use with a specific Redis instance, pass a `Redis` object to `Abaci.options[:redis]`. You can use it this way with [Redis Namespace](https://github.com/defunkt/redis-namespace) if necessary.

By default, the prefix `stats` is used before all stats stored in Redis. If you are using running multiple apps using the same Redis instance (likely in development mode), you can change the prefix by setting `Abaci.options[:prefix]`.

Here's a sample configuration that we use often:

```ruby
connection = Redis.new
REDIS = Redis::Namespace.new(:ns, :redis => connection)

Abaci.options[:redis] = REDIS
Abaci.options[:prefix] = 'stats'
```

If you are using Rails, put that in an initializer and you're good to go.

## Basic Usage

```ruby
# Log page views
Abaci['views'].increment # => 1
Abaci['views'].increment # => 2

# Increment (and decrement) all take a parameter or default to incrementing by 1
Abaci['views'].increment(3) # => 5

# Decrementing is available if needed
Abaci['views'].decrement # => 4

# Get total number of views
Abaci['views'].get # => 4

# Get total number of views in year 2012
Abaci['views'].get(2012) # => 4

# Get total number of views in October of 2012
Abaci['views'].get(2012, 10) # => 4

# Get total number of views on October 20, 2012
Abaci['views'].get(2012, 10, 20) # => 4

# Get total views in the last 30 days
Abaci['views'].get_last_days(30) # => 4

# View all counter stat keys stored
Abaci['views'].keys

# Clear counters for views
Abaci['views'].del
```

## Time Zone

When used within a Rails app, Abaci will use the same time zone as your Rails app, so there is no configuration needed.

To manually override the time zone used in Abaci, just set the config variable:

```ruby
Abaci.time_zone = "Central Time (US & Canada)"
```

## Issues

If you have any issues or find bugs running Abaci, please [report them on Github](https://github.com/jdtornow/abaci/issues). While most functions should be stable, Abaci is still in its infancy and certain issues may be present.

## License

Abaci is released under the [MIT license](http://www.opensource.org/licenses/MIT)

Contributions and pull-requests are more than welcome.
