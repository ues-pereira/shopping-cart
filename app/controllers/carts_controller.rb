class CartsController < ApplicationController

  def index
    if session[:cart_id]
      carts = Cart.find(session[:cart_id])
      render json: carts, status: :ok
    else
      render json: [], satus: :ok
    end
  end
end
