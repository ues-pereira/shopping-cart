require "rails_helper"

RSpec.describe CreateCartItemService, type: :service do
  describe '#call' do
    subject(:service) { described_class.new(product_id: product.id, quantity: quantity, cart_id: cart.id) }

    let(:product) { create(:product, name: 'Test Product', price: 10.0) }

    context 'when a cart exists' do
      let(:cart) { create(:cart) }
      let(:quantity) { 1 }

      it 'returns success' do
        response = service.call
        expect(response.success).to be(true)
      end

      it 'updates the item quantity' do
        expect { service.call }.to change { CartItem.count }.from(0).to(1)
      end

      it 'update the total_price of the cart' do
        expect { service.call }.to change { cart.reload.total_price }.from(0.0).to(10.0)
      end
    end

    context 'when cart does not exist' do
      let(:cart) { build(:cart) }
      let(:quantity) { 1 }

      it 'returns success' do
        response = service.call
        expect(response.success).to be(true)
      end

      it 'creates a new cart' do
        expect { service.call }.to change { Cart.count }.from(0).to(1)
      end

      it 'adds the product to the cart' do
        expect { service.call }.to change { CartItem.count }.from(0).to(1)
      end
    end

    context 'when params is invalid' do
      let(:cart) { create(:cart) }
      let(:quantity) { -1 }

      it 'returns success as false' do
        response = service.call
        expect(response.success).to be(false)
      end
    end

    context 'when product already registered' do
      let(:cart) { create(:cart) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }
      let(:quantity) { 1 }

      it 'returns false' do
        response = service.call
        expect(response.success).to be(false)
      end

      it 'does not update cart item' do
        expect { service.call }.to change { CartItem.count }.by(0)
      end

      it 'does not update the total_price of the cart' do
        service.call

        expect(cart.reload.total_price).to eq product.price
      end
    end
  end
end
