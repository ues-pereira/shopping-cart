class RemoveCartsAbandoned
  include Sidekiq::Job
  queue_as :remove_carts_abandoned

  def perform
    carts = Cart.active.where("last_interaction_at < ?", 7.days.ago)

    carts.find_each do |cart|
      RemoveAbandonedCartJob.perform_later(cart)
    end
  end
end
