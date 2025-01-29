require 'rails_helper'

RSpec.describe RemoveCartItemService, type: :service do
  describe '#call' do
    subject(:service) { described_class.new(product_id: product.id, cart_id: cart.id) }


    context 'when product exists in the cart' do
      let(:product) { create(:product, name: 'Test Product', price: 10.0) }
      let(:cart) { create(:cart) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

      it 'remove item with sucess' do
        expect { service.call }.to change { cart.cart_items.count }.from(1).to(0)
      end

      it 'updates total price cart' do
        expect { service.call }.to change { cart.reload.total_price }.from(10.0).to(0.0)
      end
    end

    context 'when product does not exist in the cart' do
      let(:cart) { create(:cart) }
      let(:product) { create(:product, name: 'Test Product X', price: 10.0) }

      it 'returns error message' do
        response = service.call

        expect(response.success).to be(false)
        expect(response.message).to eq 'Produto nao encontrado no carrinho'
      end
    end

    context 'when cart does not exist' do
      let(:cart) { build(:cart) }
      let(:product) { create(:product, name: 'Test Product X', price: 10.0) }

      it 'returns error message' do
        response = service.call

        expect(response.success).to be(false)
        expect(response.message).to eq 'Carrinho não foi localizado'
      end
    end

    context 'when cart has multiple item and one is removed' do
      let(:product) { create(:product, name: 'Test Product', price: 10.0) }
      let(:cart) { create(:cart) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 2) }

      it 'remove item with success' do
        expect { service.call }.to change { cart_item.reload.quantity }.from(2).to(1)
      end
    end

    context 'when params is invalid' do
      let(:product) { create(:product, name: 'Test Product', price: 10.0) }
      let(:cart) { build(:cart) }
      let(:quantity) { -1 }

      it 'returns success as false' do
        response = service.call
        expect(response.success).to be(false)
      end
    end
  end
end
