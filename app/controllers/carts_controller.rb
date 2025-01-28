class CartsController < ApplicationController

  def index
    carts = Cart.find(session[:cart_id])
    render json: carts, status: :ok
  end
end
