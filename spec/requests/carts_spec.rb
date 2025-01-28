require 'rails_helper'

RSpec.describe "Carts", type: :request do
  pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}"

  describe "GET /index" do
    context 'when session id is present' do
      it 'render a successful response with list' do
        cart = create(:cart)
        product = create(:product, name: 'Product A')
        create(:cart_item, cart: cart, product: product)
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id})

        get cart_url

        parsed_response = JSON.parse(response.body).deep_symbolize_keys

        expect(response).to be_successful
        expect(parsed_response).to include(:id, :products, :total_price)
        expect(parsed_response[:products].first).to include(:id, :name, :quantity, :unit_price, :total_price)
      end
    end

    context 'when session id is missing' do
      it 'render a successful response with empty array' do
        get cart_url

        expect(response).to be_successful
        expect(JSON.parse(response.body)).to be_empty
      end
    end
  end

  describe "POST /add_items" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, name: 'Test Product', price: 10.0) }

    context 'when the product already is in the cart' do
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

      subject do
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id})

        subject

        expect(cart_item.reload.quantity).to eq 3
      end
    end

    context 'when the product is not yet in the cart' do
      subject do
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id})

        subject

        expect(cart.cart_items.count).to eq 1
        expect(cart.cart_items.first.quantity).to eq 2
      end
    end

    context 'when params is invalid' do
      subject do
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: -1 }, as: :json
      end

      it 'returns empty array' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id})

        subject

        expect(JSON.parse(response.body)).to be_empty
      end

      it 'unprocessable entity' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id})

        subject

        expect(response).to have_http_status(422)
      end
    end
  end
end
