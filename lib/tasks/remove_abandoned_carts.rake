namespace :carts do
  namespace :abandoned do
    desc "check by carts abadoned for more 7 days ago"
    task remove: :environment do
      carts = Cart.active.where("last_interaction_at < ?", 7.days.ago)

      carts.find_each do |cart|
        MarkAbandonedCartJob.perform_later(cart)
      end
    end
  end
end
