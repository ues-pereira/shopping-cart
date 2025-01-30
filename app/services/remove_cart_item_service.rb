class RemoveCartItemService
  attr_reader :product_id, :cart_id, :cart

  def initialize(product_id:, cart_id:)
    @product_id = product_id
    @cart_id = cart_id
  end

  def call
    return handle_response(
      success: false,
      message: I18n.t("cart.item_not_found")
    ) if missing_product?

    remove_product!

    handle_response(success: true, cart: find_cart, message: I18n.t("cart.item_removed"))
  rescue StandardError => e
    handle_response(success: false, message: I18n.t("cart.not_found"))
  end

  private

  def find_cart
    @find_cart ||= Cart.find(cart_id)
  end

  def missing_product?
    find_item.blank?
  end

  def find_item
    @find_item ||= find_cart.cart_items.find { |item| item.product_id == product_id }
  end

  def remove_product!
    find_item.decrement_quantity!
  end

  def handle_response(success:, cart: nil, message:)
    OpenStruct.new(success: success, cart: cart, message: message)
  end
end
