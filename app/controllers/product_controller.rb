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
    render :json => cart_items
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :description, :user_id, :category_id, :avatar)    
  end
end
