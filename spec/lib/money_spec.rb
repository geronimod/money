require 'spec_helper'

describe Money do
  let(:money) { Money.new(10, 'EUR') }

  before do
    Money.configure do |config|
      config.default_currency = 'ARS'
      config.conversions = {
        'EUR'   => 22.35,
        'USD'   => 18.8,
        'Ether' => 0.001
      }
    end
  end

  it 'should show the amount' do
    expect(money.amount).to eq(10)
  end

  it 'should show the currency' do
    expect(money.currency).to eq('EUR')
  end

  it 'should support inspect' do
    expect(money.inspect).to eq('10 EUR')
  end

  context 'configuration' do
    it "should configure default_currency" do
      expect(Money.configuration.default_currency).to eq('ARS')
    end

    it "should configure conversions" do
      expect(Money.configuration.conversions).to be_a(Hash)
    end

    it 'should assign default currency' do
      expect(Money.new(10).currency).to eq('ARS')
    end
  end

  context 'conversion' do
    let(:usd) { money.convert_to('USD') }

    it 'should return the correct conversion value' do
      ars = money.amount * Money.configuration.conversions['EUR'] #to ARS
      expect(usd.amount).to eq(ars / Money.configuration.conversions['USD'])
    end

    it 'should convert to the same currency' do
      eth = Money.new(10, 'Ether')
      expect(eth.convert_to('Ether').amount).to eq(10)
    end
  end

  context 'comparison' do
    let(:ars) { Money.new(18.8, 'ARS') }
    let(:usd) { Money.new(1, 'USD') }
    let(:eur) { Money.new(2, 'EUR') }

    it 'should be equal' do
      expect(ars == usd).to be_truthy
    end

    it 'should be greater' do
      expect(ars < eur).to be_truthy
    end

    it 'should be less' do
      expect(eur > usd).to be_truthy
    end
  end

  context 'arithmetic' do
    let(:fifty_eur) { Money.new(50, 'EUR') }
    let(:twenty_dollars) { Money.new(20, 'USD') }

    it 'should ' do
      expect(fifty_eur + twenty_dollars).to eq(Money.new(66.82326621923937, 'EUR'))
    end

    it 'supports +' do
      expect(fifty_eur + 5).to eq(Money.new(55, 'EUR'))
    end

    it 'supports -' do
      expect(fifty_eur - 5).to eq(Money.new(45, 'EUR'))
    end

    it 'supports /' do
      expect(fifty_eur / 5).to eq(Money.new(10, 'EUR'))
    end

    it 'supports *' do
      expect(fifty_eur * 3).to eq(Money.new(150, 'EUR'))
    end
  end
end