class UpdateCartItemService
  attr_reader :product_id, :quantity, :cart_id, :cart

  def initialize(product_id:, quantity:, cart_id:)
    @product_id = product_id
    @quantity = quantity
    @cart_id = cart_id
    @cart = find_or_create_cart
  end

  def call
    return handle_response(success: false, card: card) if params_invalid?

    item = find_or_add_item
    item.increment_quantity!(quantity)

    handle_response(success: true, cart: cart)
  rescue StandardError => e
    handle_response(success: false, cart: cart)
  end

  private

  def params_invalid?
    product_id.nil || quantity.nil || quantity.negative?
  end

  def find_or_create_cart
    Cart.find_or_create_by!(id: cart_id)
  end

  def find_or_add_item
    binding.pry
    cart.cart_items.find_or_create_by!(product_id: product_id)
  end

  def handle_response(success:, cart:)
    OpenStruct.new(success: success, cart: cart)
  end
end
