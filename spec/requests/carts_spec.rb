require 'rails_helper'

RSpec.describe "Carts", type: :request do
  pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}"

  describe "GET /index" do
    context 'when has products in the cart' do
      it 'render a successful response' do
        cart = create(:cart)
        product = create(:product, name: 'Product A')
        create(:cart_item, cart: cart, product: product)
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id})

        get carts_url

        parsed_response = JSON.parse(response.body).deep_symbolize_keys

        expect(response).to be_successful
        expect(parsed_response).to include(:id, :products, :total_price)
        expect(parsed_response[:products].first).to include(:id, :name, :quantity, :unit_price, :total_price)
      end
    end
  end

  describe "POST /add_items" do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
