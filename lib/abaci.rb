require 'abaci/version'

module Abaci
  # Configuration options
  class << self
    def options
      @options ||= {
        :redis => nil,
        :prefix => 'ab'
      }
    end
  end
end