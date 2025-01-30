class UpdateCartItemService
  attr_reader :product_id, :quantity, :cart_id, :cart

  def initialize(product_id:, quantity:, cart_id:)
    @product_id = product_id
    @quantity = quantity
    @cart_id = cart_id
    @cart = find_or_create_cart
  end

  def call
    return handle_response(success: false, cart: cart, message: I18n.t("cart.invalid_params")) if params_invalid?
    return handle_response(success: false, cart: cart, message: I18n.t("cart.invalid_product")) if product_invalid?

    ActiveRecord::Base.transaction do
      item = find_or_add_item
      item.increment_quantity!(quantity)
    end

    handle_response(success: true, cart: cart)
  rescue StandardError => e
    handle_response(success: false, cart: cart, message: e.message)
  end

  private

  def params_invalid?
    product_id.nil? || quantity.nil? || quantity.negative?
  end

  def product_invalid?
    Product.find_by(id: product_id).nil?
  end

  def find_or_create_cart
    Cart.find_or_create_by!(id: cart_id)
  end

  def find_or_add_item
    cart.cart_items.find_or_create_by!(product_id: product_id)
  end

  def handle_response(success:, cart:, message: nil)
    OpenStruct.new(success: success, cart: cart, message: message)
  end
end
