#
# Activities related to products
#
# @author [qbuser]
#
class ProductController < ApplicationController
  # For creating new product
  #
  def new
    @company = current_user.id
    @product = Product.new
    @categories = Category.all
    4.times { @product.product_images.build }
  end

  # Populates the edit page for product
  #
  def edit
    @company = current_user.id
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  # Creates a new product
  #
  def create
    @product = Product.new(product_params)
    if @product.save
      activity_log("added product <b>#{@product.name}</b> to #{@product.category.name}")
      redirect_to company_index_path
    else
      @categories = Category.all
      4.times { @product.product_images.build }
      render 'new'
    end
  end

  # Saves changes to the product
  #
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      activity_log('edited a product')
      redirect_to company_index_path
    else
      @categories = Category.all
      render 'edit'
    end
  end

  # Removes a product
  #
  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      activity_log('deleted a product')
      redirect_to company_index_path
    end
  end

  # Get the details of a product
  #
  def show
    @product = Product.select('id', 'name', 'price', 'quantity', 'description', 'users.first_name AS brand').joins(:user).find(params[:id])
    @product_images = @product.product_images.map { |i| i.image.url }
    @review = Review.new
    @old_reviews = Review.where(product_id: params[:id])
    session[:previous_url] = request.fullpath # return after sign_in
  end

  # check whether quantity minus inventory becomes less than 0
  #
  def check_inventory
    quantity = Product.find(params[:product]).quantity
    respond_to do |format|
      if quantity - params[:quantity].to_i < 0
        format.json { render json: 'false' }
      else
        format.json { render json: 'true' }
      end
    end
  end

  # Get products in cart session
  #
  def view_cart
    session[:previous_url] = request.fullpath
    if session[:cart].present?
      @sum = 0
      @count = 0
      @items = session[:cart]
      @items.each do |item|
        product = Product.find(item['product'])
        @sum += product.price * item['quantity'].to_i
        @count += item['quantity'].to_i
      end
    end
  end
  
  # Stores the product id's to session
  #
  def add_to_cart
    session[:cart] = [] if session[:cart].nil?
    unless session[:cart].any? { |h| h['product'] == params[:product] }
      session[:cart] << { 'product' => params[:product], 'quantity' => params[:quantity] }
    else
      index = session[:cart].index { |item| item['product'] == params[:product] }
      session[:cart][index]['quantity'] = params[:quantity]
    end
    render :partial => 'mini_cart'
  end

  # Remove the element at 'arr_pos' from session
  #
  def remove_from_cart
    pos = params[:arr_pos].to_i
    session[:cart].delete_at(pos)
    return redirect_to view_cart_path if session[:previous_url] == '/cart'
    render json: session[:cart]
  end

  # Add to wishlist
  #
  def add_to_wishlist
    if session[:wishlist].nil?
      session[:wishlist] = []
      session[:wishlist] << params[:id]
    else
      unless session[:wishlist].include?(params[:id])
        session[:wishlist] << params[:id]
      end
    end
    redirect_to wishlist_path
  end

  # Show products in wishlist session
  #
  def wishlist
    if session[:wishlist].present?
      @products = session[:wishlist].map do |id|
        Product.find(id)
      end
    end
  end

  # Remove product from wishlist session
  #
  def remove_from_wishlist
    index = params[:index].to_i
    session[:wishlist].delete_at(index)
    redirect_to wishlist_path
  end

  # Add to compare session
  #
  def add_to_compare
    if session[:compare].present?
      items = session[:compare].split(',')
      unless items.include? params[:product_id]
        # pop the first element if size > 4
        if items.size == 4
          items.shift
          session[:compare] = items.join(',')
        end
        session[:compare] << ',' + params[:product_id]
      end
    else
      session[:compare] = params[:product_id]
    end
    flash[:compare] = 'Product has been added '
    redirect_to product_path(params[:product_id])
  end

  # Remove product from compare session
  #
  def remove_from_compare
   pos = params[:index].to_i
   compare_items = session[:compare].split(',')
   compare_items.delete_at(pos)
   session[:compare] = compare_items.join(',')
   redirect_to(compare_product_path)
  end

  # Get products in compare session
  #
  def show_compare
    if session[:compare].present?
      @items = session[:compare].split(',')
      @products = @items.map do |item|
        product = Product.find(item)
        [
          product.name,
          product.product_images[0].image.url(:thumb),
          product.description,
          product.price,
          product.user.first_name,
          product.id
        ]
      end
      @table_headers = ['Product', 'Image', 'Summary', 'Price', 'Manufacturer', '']
    end
  end

  private

  def product_params
    params.require(:product).permit!
  end
end
