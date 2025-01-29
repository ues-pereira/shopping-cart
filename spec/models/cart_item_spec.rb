require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let!(:cart) { create(:cart) }
  let!(:product) { create(:product, price: 10.0) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 2) }

  describe '#total_price' do
    it 'calculates the total price correctly' do
      expect(cart_item.total_price).to eq(20.0)
    end
  end

  describe '#increment_quantity!' do
    it 'increments the quantity by the given value' do
      expect { cart_item.increment_quantity!(3) }.to change { cart_item.reload.quantity }.by(3)
    end
  end

  describe '#decrement_quantity!' do
    context 'when quantity is greater than 1' do
      it 'decrements the quantity by 1' do
        expect { cart_item.decrement_quantity! }.to change { cart_item.reload.quantity }.by(-1)
      end
    end

    context 'when quantity is 1' do
      before { cart_item.update!(quantity: 1) }

      it 'deletes the cart item when quantity reaches 0' do
        expect { cart_item.decrement_quantity! }.to change { CartItem.count }.by(-1)
      end
    end
  end

  describe 'after commit' do
    it 'calls #update_cart_total_price on the cart' do
      expect(cart).to receive(:set_total_price)
      cart_item.save!
    end
  end
end
