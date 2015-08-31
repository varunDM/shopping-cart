# Manage the operations related to Products
class ProductController < ApplicationController
  # For creating new product
  def new
    @company = current_user.id
    @product = Product.new
    @categories = Category.all
    4.times { @product.product_images.build }
  end

  # Populates the edit page for product
  def edit
    @company = current_user.id
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  # Creates a new product
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
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      activity_log("edited a product")
      redirect_to company_index_path
    else
      @categories = Category.all
      render 'edit'
    end
  end

  # Removes a product
  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      activity_log("deleted a product")
      redirect_to company_index_path
    end
  end

  # Get the details of a product
  def show
    @product = Product.find(params[:id])
    @review = Review.new
    session[:previous_url] = request.fullpath
    @old_reviews = Review.where(:product_id => params[:id])
    p @old_reviews
  end

  # Stores the product id's to session
  def add_to_cart
    if session[:cart].nil?
      session[:cart] = []
    end
    unless session[:cart].any?{ |h| h['product'] == params[:product]}
      p session[:cart]
      session[:cart] << { 'product' => params[:product], 'quantity' => params[:quantity] }
      p session[:cart]
    else
      index = session[:cart].index { |item| item['product'] == params[:product] }
      session[:cart][index]['quantity'] = params[:quantity]

    end
    p session[:cart]
    # render :json => @product.as_json(methods: :image_url)
    render :partial => 'mini_cart'
  end

  # Remove the element at 'arr_pos' from session
  def remove_from_cart
    pos = params[:arr_pos].to_i
    session[:cart].delete_at(pos)
    return redirect_to view_cart_path if session[:previous_url] == '/cart'
    render :json => session[:cart]
  end

  # Add to wishlist
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

  def wishlist
    if session[:wishlist].present?
      @products = session[:wishlist].map do |id|
        Product.find(id)
      end
    end
  end

  def remove_from_wishlist
    index = params[:index].to_i
    session[:wishlist].delete_at(index)
    redirect_to wishlist_path
  end

  # Add to compare session
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

  def remove_from_compare
   pos = params[:index].to_i
   compare_items = session[:compare].split(',')
   compare_items.delete_at(pos)
   session[:compare] = compare_items.join(',')
   redirect_to(compare_product_path)
  end

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
