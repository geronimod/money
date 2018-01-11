module Money
  class Base
    include Comparable

    attr_reader :amount, :currency

    def initialize(amount, currency)
      @amount, @currency = amount, currency
    end

    def inspect
      "#{@amount} #{@currency}"
    end

    def convert_to(to_curr)
      self.class.new(convert(to_curr), to_curr)
    end

    def <=>(other)
      @amount <=> other.convert_to(@currency).amount
    end

    def +(other)
      arith(:+, other)
    end

    def -(other)
      arith(:-, other)
    end

    def *(other)
      arith(:*, other)
    end

    def /(other)
      arith(:/, other)
    end

    private

    def arith(op, obj)
      if obj.is_a?(Money::Base)
        arith op, obj.convert_to(@currency).amount
      else
        @amount = @amount.send(op, obj)
      end

      self
    end

    def convert_to_default_currency
      @amount * conversions[@currency]
    end

    def convert(to_curr)
      convert_to_default_currency / conversions[to_curr]
    end

    def default_currency
      Money.configuration.default_currency
    end

    def conversions
      Money.configuration.conversions
    end
  end
end