class MarkAbandonedCartJob < ApplicationJob
  queue_as :abandoned_cart

  def perform(cart)
    cart.abandoned! if cart.active? && cart.last_interaction_at < 3.hours.ago
   end
end
