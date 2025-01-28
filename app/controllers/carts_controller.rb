class CartsController < ApplicationController
  before_action :cart_id

  def show
    if session[:cart_id]
      carts = Cart.find(session[:cart_id])
      render json: carts, status: :ok
    else
      render json: [], satus: :ok
    end
  end

  def create
    response = CreateCartItemService.new(**permitted_params.merge(cart_id)).call

    if response.success
      session[:cart_id] = response.cart.id
      render json: response.cart, status: :created
    else
      render json: [], status: :unprocessable_entity
    end
  end

  def add_item
    response = UpdateCartItemService.new(**permitted_params.merge(cart_id)).call

    if response.success
      render json: response.carts, status: :ok
    else
      render json: [], status: :unprocessable_entity
    end
  end

  private

  def cart_id
    { cart_id: session[:cart_id] }
  end

  def permitted_params
    params.permit(:product_id, :quantity).to_h.deep_symbolize_keys
  end
end
