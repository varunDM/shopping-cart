#
class CheckoutController < ApplicationController
  
  before_action :authenticate_user!, except: :view_cart


  def index
    @user = current_user
    @address_new = BillAddress.new
    @address_old = BillAddress.where(:user_id => @user.id)
    session[:quantity] = params[:quantity]
    session[:product] = params[:product_id]
    session[:check_out_url] = request.fullpath
  end

  def view_cart
    session[:previous_url] = request.fullpath
    if session[:cart].present?
      @sum = 0
      @items = session[:cart]
      @items.each_with_index do |item, index|
        product = Product.find(item['product'])
        @sum += product.price * item['quantity'].to_i
        @count = index + 1
      end
    end
  end

  def purchase_show
    if params[:product_id] == '0'
      @sum = 0
      @items = session[:cart]
      @items.each_with_index do |item, index|
        product = Product.find(item['product'])
        @sum += product.price * item['quantity'].to_i
        @count = index + 1
      end
    else
      @products = Product.find(params[:product_id])
    end
    @address = BillAddress.find(params[:bill_address_id])
    @user = current_user
  end

  def purchase_action
    # from cart
    if params[:product_id] == '0'
      @items = items_from_cart
      @purchase = Purchase.new(:bill_address_id => params[:bill_address_id], :ip =>  IPAddr.new(request.remote_ip).to_i)
      @purchase.save
      @items.each do |item|
        @purchase_products = PurchaseProduct.new(:purchase_id => @purchase.id, :product_id => item.id )
        @purchase_products.save
        stock_minus(item.id)
      end
      UserMailer.purchase_email(params, session[:cart]).deliver
      session[:purchased_item] = params[:product_id]
      redirect_to purchase_success_path
    # via product page
    else
      @purchase = Purchase.new(:bill_address_id => params[:bill_address_id], :ip =>  IPAddr.new(request.remote_ip).to_i)
      if @purchase.save
        @purchase_products = PurchaseProduct.new(:purchase_id => @purchase.id, :product_id => params[:product_id], :quantity => session[:quantity])
        @purchase_products.save
        stock_minus(params[:product_id], session[:quantity])
        # Send email
        UserMailer.purchase_email(params, session[:cart]).deliver
        session[:purchased_item] = params[:product_id]
        redirect_to purchase_success_path
      else
        render 'purchase_show'
      end
    end
  end

  def stock_minus(product, amount)
    product = Product.find(product)
    quantity = product.quantity
    quantity -= amount.to_i
    product.update(:quantity => quantity)
  end

  def items_from_cart
    items = session[:cart]
    products = []
    items.each do |item|
      products << Product.find(item['product'])
      products[:amount] = item['amount']
    end
    return products
  end


  def success
    if session[:purchased_item] == '0'
      @products = items_from_cart
      session.delete(:cart)
    else
      item = session[:purchased_item]
      @products = Product.find(item)
    end
  end

end
