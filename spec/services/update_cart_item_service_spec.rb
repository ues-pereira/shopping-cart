require "rails_helper"

RSpec.describe UpdateCartItemService, type: :service do
  describe '#call' do
    subject(:service) { described_class.new(product_id: product.id, quantity: quantity, cart_id: cart.id) }

    let(:cart) { create(:cart) }
    let(:product) { create(:product, name: 'Test Product', price: 10.0) }

    context 'when the product already is in the cart' do
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }
      let(:quantity) { 1 }

      it 'returns success' do
        response = service.call
        expect(response.success).to be(true)
      end

      it 'updates the item quantity' do
        expect { service.call }.to change { cart_item.reload.quantity }.from(1).to(2)
      end

      it 'update the total_price of the cart' do
        expect { service.call }.to change { cart.reload.total_price }.from(10.0).to(20.0)
      end
    end

    context 'when the product is not in the cart' do
      let(:quantity) { 2 }

      it 'returns success' do
        response = service.call
        expect(response.success).to be(true)
      end

      it 'adds the product to the cart' do
        expect { service.call }.to change { CartItem.count }.from(0).to(1)
      end

      it 'updates the total_price of the cart' do
        expect { service.call }.to change { cart.reload.total_price }.from(0.0).to(20.0)
      end
    end

    context 'when params is invalid' do
      let(:quantity) { -1 }

      it 'returns false for success' do
        response = service.call
        expect(response.success).to be(false)
      end
    end

    context 'when unexpected error occurs' do
      let(:quantity) { 1 }

      it  'returns false for success' do
        allow_any_instance_of(cart.cart_items.class).to receive(:find_or_create_by!).and_raise(ActiveRecord::RecordInvalid)
        response = service.call

        expect(response.success).to be(false)
        expect(response.message).to eq 'Record invalid'
      end
    end
  end
end
