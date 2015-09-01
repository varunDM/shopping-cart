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
      @count = 0
      @items = session[:cart]
      @items.each_with_index do |item, index|
        product = Product.find(item['product'])
        @sum += product.price * item['quantity'].to_i
        @count += item['quantity'].to_i
      end
    end
  end

  def purchase_show
    if params[:product_id] == '0'
      p 'herreeeeeeeeeeeeeee'
      @items = session[:cart]
    else
      @items = []
      @items << { 'product' => params[:product_id], 'quantity' => session[:quantity] }
    end
    @sum = 0
    @count = 0
    @items.each_with_index do |item, index|
      product = Product.find(item['product'])
      @sum += product.price * item['quantity'].to_i
      @count += item['quantity'].to_i
    end
    @address = BillAddress.find(params[:bill_address_id])
    @user = current_user
  end

  def purchase_action
    # from cart
    if params[:product_id] == '0'
      @items = session[:cart]
      @purchase = Purchase.new(:bill_address_id => params[:bill_address_id], :ip =>  IPAddr.new(request.remote_ip).to_i)
      @purchase.save
      @items.each do |item|
        @purchase_products = PurchaseProduct.new(:purchase_id => @purchase.id, :product_id => item['product'], :quantity =>  item['quantity'])
        @purchase_products.save
        stock_minus(item['product'], item['quantity'])
      end
      UserMailer.purchase_email('cart',@purchase, session[:cart]).deliver
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
        UserMailer.purchase_email('product',@purchase, session[:cart]).deliver
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
      product =  Product.find(item['product'])
      products << { :name => product.name, :price => product.price, :image => product.product_images[0].image.url(:thumb), :quantity => item['quantity'] }
    end
    return products
  end

  def success
    if session[:purchased_item] == '0'
      @items = items_from_cart
      session.delete(:cart)
    else
      item = Product.find(session[:purchased_item])
      @items = []
      @items << { :name => item.name, :price => item.price, :image => item.product_images[0].image.url(:thumb), :quantity => session[:quantity] }
    end
    @sum = 0
    @count = 0
    @items.each_with_index do |item, index|
      @sum += item[:price] * item[:quantity].to_i
      @count += item[:quantity].to_i
    end
  end
end
