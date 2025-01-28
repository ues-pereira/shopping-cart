class CreateCartItemService
  attr_reader :product_id, :quantity, :cart_id, :cart

  def initialize(product_id:, quantity:, cart_id:)
    @product_id = product_id
    @quantity = quantity
    @cart_id = cart_id
    @cart = find_or_create_cart
  end

  def call
    return handle_response(success: false, card: card) if params_invalid?
    return handle_response(success: false, card: card) if already_item?

    item = add_item
    item.increment_quantity!(quantity)

    handle_response(success: true, cart: cart)
  rescue StandardError => e
    handle_response(success: false, cart: cart)
  end

  private

  def params_invalid?
    product_id.nil? || quantity.nil? || quantity.negative?
  end

  def already_item?
    cart.cart_items.any? {|item| item.product.id = product_id}
  end

  def find_or_create_cart
    Cart.find_or_create_by!(id: cart_id)
  end

  def add_item
    cart.cart_items.create(product_id: product_id)
  end

  def handle_response(success:, cart:)
    OpenStruct.new(success: success, cart: cart)
  end
end
