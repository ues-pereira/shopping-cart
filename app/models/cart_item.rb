class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  after_commit :update_cart_total_price

  def total_price
    product.price * quantity
  end

  private

  def update_cart_total_price
    cart.set_total_price
  end
end
