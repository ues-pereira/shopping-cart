require 'rails_helper'
RSpec.describe RemoveCartsAbandonedJob, type: :job do
  describe '#perform' do
  let(:old_cart) { create(:cart, last_interaction_at: 8.days.ago, status: :abandoned) }
  let(:recent_cart) { create(:cart, last_interaction_at: 6.days.ago, status: :abandoned) }


    it 'enqueues RemoveAbandonedCartJob for carts inactive for more than 7 days' do
      expect(RemoveAbandonedCartJob).to receive(:perform_later).with(old_cart).once
      expect(RemoveAbandonedCartJob).not_to receive(:perform_later).with(recent_cart)

      described_class.new.perform
    end
  end
end
