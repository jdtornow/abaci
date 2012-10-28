module Abaci
  class Counter
    attr_reader :key

    def initialize(category = nil)
      @category = category
      @key = category
    end

    def decr(by = 1)
      run(:decrby, by)
    end
    alias_method :decrement, :decr

    def del
      keys.each { |k| Abaci.store.del(k) }
      true
    end

    def get(year = nil, month = nil, day = nil, hour = nil, min = nil)
      get_key = [ key, year, month, day, hour, min ].compact.join(':')
      Abaci.store.get(get_key).to_i
    end

    def get_last_days(number_of_days = 30)
      dates = (number_of_days.to_i.days.ago.to_date..Date.today).map { |d| d.strftime('%Y:%-m:%-d') }
      dates.map { |date| Abaci.store.get("#{key}:#{date}" ).to_i }.reduce(:+)
    end

    def incr(by = 1)
      run(:incrby, by)
    end
    alias_method :increment, :incr

    def keys
      Abaci.store.keys("#{key}*")
    end

    ## Class methods ##
    ############################################################################

    # Returns a hash of all current values
    def self.all
      keys.inject({}) { |hash, key| hash[key] = Abaci.store.get(key).to_i; hash }
    end

    # Gets all currently logged stat keys
    def self.keys(search = "*")
      Abaci.store.keys(search).sort
    end

    # Alias for Counter#new(key)
    def self.[](key)
      Counter.new(key)
    end

    def self.method_missing(method, *args)
      ms = method.to_s.downcase.strip

      if ms =~ /(incr|decr)(ement|ease)?_([a-z_]*)$/
        return self[$3].send($1, *args)
      elsif ms =~ /^(clear|reset|del)_([a-z_]*)!$/
        return self[$2].del
      elsif ms =~ /^last_(\d*)_days_of_([a-z_]*)$/
        return self[$2].get_last_days($1)
      elsif ms =~ /[a-z_]*/
        return self[ms].get(*args)
      end

      super
    end

    ## Protected methods ##
    ############################################################################

    protected
      def run(method, by)
        now = Time.now.strftime('%Y/%m/%d/%k/%M').split('/')

        now.inject(key) do |memo, t|
          memo = "#{memo}:#{t.to_i}"
          Abaci.store.send(method, memo, by)
          memo
        end

        Abaci.store.send(method, key, by)
      end
  end
end