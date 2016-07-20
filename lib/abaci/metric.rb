module Abaci
  class Metric

    def self.add(key)
      Abaci.store.sadd("#{ Abaci.options[:separator] }metrics", key)
    end

    def self.all
      Abaci.store.smembers("#{ Abaci.options[:separator] }metrics")
    end

    def self.remove(key)
      Abaci.store.srem("#{ Abaci.options[:separator] }metrics", key)
    end

  end
end
