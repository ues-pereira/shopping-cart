class RemoveAbandonedCartJob < ApplicationJob
  queue_as :remove_abandoned_cart

  def perform(cart)
    cart.remove_if_abandoned if cart.abandoned?
  end
end
