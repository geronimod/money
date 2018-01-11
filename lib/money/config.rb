module Money
  class Config
    attr_accessor :default_currency, :conversions

    def initialize
      @default_currency = 'USD'
      @conversions      = { 'USD' => 1 }
    end

    def default_currency=(currency)
      @default_currency = currency
      add_default_conversion
    end

    def conversions=(hash)
      @conversions = hash
      add_default_conversion
    end

    private

    def add_default_conversion
      @conversions[@default_currency] = 1
    end
  end
end
