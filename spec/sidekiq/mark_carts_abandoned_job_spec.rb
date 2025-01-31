require 'rails_helper'
RSpec.describe MarkCartsAbandonedJob, type: :job do
  describe '#perform' do
  let(:old_cart) { create(:cart, last_interaction_at: 4.hours.ago, status: :active) }
  let(:recent_cart) { create(:cart, last_interaction_at: 2.hours.ago, status: :active) }


    it 'enqueues AbandonCartJob for carts inactive for more than 3 hours' do
      expect(AbandonCartJob).to receive(:perform_later).with(old_cart).once
      expect(AbandonCartJob).not_to receive(:perform_later).with(recent_cart)

      described_class.new.perform
    end
  end
end
