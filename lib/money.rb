require "money/version"
require "money/config"
require "money/base"

module Money
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Config.new
      yield(configuration) if block_given?
      configuration
    end

    def new(amount, currency = configuration.default_currency)
      Base.new(amount, currency)
    end
  end
end
