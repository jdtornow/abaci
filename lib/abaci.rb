require 'abaci/version'

module Abaci
  autoload :Counter,      'abaci/counter'
  autoload :Store,        'abaci/store'

  # Configuration options
  class << self
    def [](key)
      Counter[key]
    end

    def options
      @options ||= {
        :redis => nil,
        :prefix => 'ab'
      }
    end

    def prefix
      options[:prefix]
    end

    def store
      @store ||= Store.new(options)
    end
  end
end