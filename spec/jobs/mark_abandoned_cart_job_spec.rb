require 'rails_helper'

describe MarkAbandonedCartJob, type: :job do
  describe '#perform' do
    context 'when cart is inactive for more than 3 hours' do
      let(:cart) { create(:cart, last_interaction_at: 3.hours.ago, status: :active) }

      it 'marks as abandoned' do
        expect { MarkAbandonedCartJob.perform_now(cart) }
          .to change { cart.reload.status }.from("active").to("abandoned")
      end
    end

    context 'when cart is inactive for less than 3 hours' do
      let(:cart) { create(:cart, last_interaction_at: 2.hours.ago, status: :active) }

      it 'keeps active status' do
        expect { MarkAbandonedCartJob.perform_now(cart) }
          .to_not change { cart.reload.status }
      end
    end
  end
end
