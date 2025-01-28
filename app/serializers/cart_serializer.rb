class CartSerializer < ActiveModel::Serializer
  attributes :id
  attributes :total_price

  attributes :products

  def products
    object.cart_items.map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.price,
        total_price: item.total_price
      }
    end
  end
end
