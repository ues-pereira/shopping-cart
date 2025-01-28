class CartsController < ApplicationController
  before_action :cart_id

  def index
    if session[:cart_id]
      carts = Cart.find(session[:cart_id])
      render json: carts, status: :ok
    else
      render json: [], satus: :ok
    end
  end

  def add_items
    UpdateCartItemService.new(**permitted_params.merge(cart_id)).call
  end

  private

  def cart_id
    { cart_id: session[:cart_id] }
  end

  def permitted_params
    params.permit(:product_id, :quantity).to_h.deep_symbolize_keys
  end
end
