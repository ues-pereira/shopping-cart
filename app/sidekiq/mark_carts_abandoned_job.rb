class MarkCartsAbandonedJob
  include Sidekiq::Job
  queue_as :mark_carts_abandoned

  def perform
    carts = Cart.active.where("last_interaction_at < ?", 3.hours.ago)

    carts.find_each do |cart|
      AbandonCartJob.perform_later(cart)
    end
  end
end
