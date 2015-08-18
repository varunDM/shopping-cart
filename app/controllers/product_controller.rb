# Manage the operations related to Products
class ProductController < ApplicationController
  # For creating new product
  def new
    @company = current_user.id
    @product = Product.new
    @categories = Category.all
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
      redirect_to company_index_path
    else
      @categories = Category.all
      render 'new'
    end
  end

  # Saves changes to the product
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to company_index_path
    else
      @categories = Category.all
      render 'edit'
    end
  end

  # Removes a product
  def destroy
    @product = Product.find(params[:id])
    redirect_to company_index_path if @product.destroy
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
    if session[:cart].present?
      session[:cart] << ',' + params[:product]
    else
      session[:cart] = params[:product]
    end
    @product = Product.find(params[:product])
    render :json => @product.as_json(methods: :avatar_url)
  end

  # Remove the element at 'arr_pos' from session
  def remove_from_cart
    pos = params[:arr_pos].to_i
    cart_items = session[:cart].split(',')
    cart_items.delete_at(pos)
    session[:cart] = cart_items.join(',')
    return redirect_to view_cart_path if session[:previous_url] == '/cart'
    render :json => cart_items
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
    @products = Array.new
    session[:wishlist].each do |id|
      @products << Product.find(id)
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
      @products = Array.new
      @items.each_with_index do |item, index|
        product = Product.find(item)
        prd_fields = Array.new
        prd_fields.push(product.name)
        prd_fields.push(product.avatar.url(:thumb))
        prd_fields.push(product.price)
        prd_fields.push(product.user.first_name)
        prd_fields.push(product.id)
        @products.push(prd_fields)
      end
      @products = @products.transpose
      @table_headers = ['Product', 'Image', 'Price', 'Manufacturer']
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :description, :user_id, :category_id, :avatar)    
  end
end
