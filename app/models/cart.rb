class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  after_commit :update_last_interaction_at

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  enum status: { active: 0, abandoned: 1 }

  def mark_as_abandoned
    return if abandoned? || last_interaction_at > 3.hours.ago

    abandoned!
  end

  def remove_if_abandoned
    destroy if last_interaction_at.in_time_zone < 7.days.ago.in_time_zone
  end

  def set_total_price
    total_price = cart_items.reload.sum(&:total_price)
    update(total_price: total_price)
  end

  private

  def update_last_interaction_at
    return if last_interaction_at < 3.hours.ago

    update_column(:last_interaction_at, Time.current) if active?
  end
end
