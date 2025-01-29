class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  after_commit :update_cart_total_price

  def total_price
    product.price * quantity
  end

  def increment_quantity!(quantity)
    update!(quantity: self.quantity + quantity)
  end

  def decrement_quantity!
    new_quantity = [self.quantity - 1, 0].max

    update!(quantity: new_quantity)
  end

  private

  def update_cart_total_price
    cart.set_total_price
  end
end
