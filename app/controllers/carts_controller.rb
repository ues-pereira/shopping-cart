class CartsController < ApplicationController
  before_action :cart_id

  def show
    if session[:cart_id]
      cart = Cart.find(session[:cart_id])
      render json: cart, status: :ok
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
      render json: response.message, status: :unprocessable_entity
    end
  end

  def add_item
    response = UpdateCartItemService.new(**permitted_params.merge(cart_id)).call

    if response.success
      session[:cart_id] = response.cart.id
      render json: response.cart, status: :ok
    else
      render json: response.message, status: :unprocessable_entity
    end
  end

  def remove_item
    response = RemoveCartItemService.new(**permitted_params.merge(cart_id)).call

    return render json: response.cart, status: :ok if response.success && response.cart.cart_items.present?
    return render json: [], status: :ok if response.success && response.cart.cart_items.blank?
    return render json: response.message, status: :unprocessable_entity
  end

  private

  def cart_id
    { cart_id: session[:cart_id] }
  end

  def permitted_params
    params.permit(:product_id, :quantity).to_h.deep_symbolize_keys.transform_values(&:to_i)
  end
end
