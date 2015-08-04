#
class CheckoutController < ApplicationController
  
  before_action :authenticate_user!

  def get
    @product = Product.find(params[:id])
  end
end
