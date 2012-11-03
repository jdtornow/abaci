module Abaci
  class Metric
    def self.add(key)
      Abaci.store.sadd('_metrics', key)
    end

    def self.all
      Abaci.store.smembers('_metrics')
    end

    def self.remove(key)
      Abaci.store.srem('_metrics', key)
    end
  end
end