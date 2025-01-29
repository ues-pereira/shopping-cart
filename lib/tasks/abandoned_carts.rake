namespace :carts do
  desc "check by carts abadoned for more 3 hours ago"
  task abandoned: :environment do
    carts = Cart.active.where("last_interaction_at < ?", 3.hours.ago)

    carts.find_each do |cart|
      MarkAbandonedCartJob.perform_later(cart)
    end
  end
end
