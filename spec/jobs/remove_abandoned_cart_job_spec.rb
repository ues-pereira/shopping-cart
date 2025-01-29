require 'rails_helper'

describe RemoveAbandonedCartJob, type: :job do
  describe '#perform' do
    context 'when cart is abandoned for more than 7 days' do
      let!(:cart) { create(:cart, last_interaction_at: 8.days.ago, status: :abandoned) }

      it 'removes abandoned cart' do
        expect { RemoveAbandonedCartJob.perform_now(cart) }
          .to change { Cart.count }.by(-1)
      end
    end

    context 'when cart is abandoned for less than 7 days' do
      let!(:cart) { create(:cart, last_interaction_at: 6.days.ago, status: :abandoned) }

      it 'keeps active status' do
        expect { MarkAbandonedCartJob.perform_now(cart) }
          .to_not change { Cart.count }
      end
    end
  end
end
