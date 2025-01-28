require 'rails_helper'

RSpec.describe CartSerializer, type: :serializer do
  let(:cart) { create(:cart) }
  let(:product) { create(:product, name: 'Product A', price: 10.0) }

  before do
    create(:cart_item, cart: cart, product: product, quantity: 2)
  end

  subject(:serializer) { described_class.new(cart).as_json }

  it 'builds the attributes' do
    expect(serializer[:id]).to eq cart.id
    expect(serializer[:total_price]).to eq cart.total_price
    expect(serializer[:products].first[:id]).to eq product.id
    expect(serializer[:products].first[:name]).to eq product.name
    expect(serializer[:products].first[:quantity]).to eq 2
    expect(serializer[:products].first[:unit_price]).to eq product.price
    expect(serializer[:products].first[:total_price]).to eq 20
  end
end
