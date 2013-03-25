class OrderController < ApplicationController
  before_filter :authenticate_user!

  def update
    @order = Order.find(params[:id])
    if @order.state == params[:state]
      @order.switch_to_next_state
    else
      render status: 400
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.cancel
  end
end
