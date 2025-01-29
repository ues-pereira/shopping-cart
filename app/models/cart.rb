class Cart < ApplicationRecord
  has_many :cart_items
  has_many :products, through: :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado

  def set_total_price
    total_price = cart_items.reload.sum(&:total_price)
    update(total_price: total_price)
  end
end
