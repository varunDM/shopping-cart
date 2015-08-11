#
class CheckoutController < ApplicationController
  
  before_action :authenticate_user!


  def index
    @user = current_user
    @address_new = BillAddress.new
    @address_old = BillAddress.where(:user_id => @user.id)
  end

  def purchase_show
    if params[:product_id] == '0'
      @products = items_from_cart
    else
      @products = Product.find(params[:product_id])
    end
    @address = BillAddress.find(params[:bill_address_id])
    @user = current_user
  end

  def purchase_action
    if params[:product_id] == '0'
      @items = items_from_cart
      @items.each do |item|
        @purchase = Purchase.new( :product_id => item.id, :bill_address_id => params[:bill_address_id])
        @purchase.save
      end

      flash[:purchased_item] = params[:product_id]
      redirect_to purchase_success_path
    else
      @purchase = Purchase.new(purchase_params)
      if @purchase.save
        # Send email
        UserMailer.purchase_email(@purchase).deliver
        flash[:purchased_item] = params[:product_id]
        redirect_to purchase_success_path
      else
        render 'purchase_show'
      end
    end
   
  end

  def items_from_cart
    items = session[:cart].split(',')
    products = []
    items.each do |item|
      products << Product.find(item)
    end
    return products
  end


  def success
    if flash[:purchased_item] == '0'
      @products = items_from_cart
      session.delete(:cart)
    else
      item = flash[:purchased_item]
      @products = Product.find(item)
    end
  end

  private

  def purchase_params
    params.permit(:product_id, :bill_address_id)    
  end
end
