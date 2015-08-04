#
class ProductController < ApplicationController
  def new
    @company = current_user.id
    @product = Product.new
    @categories = Category.all
  end

  def edit
    @company = current_user.id
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to company_index_path
    else
      @categories = Category.all
      render 'new'
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to company_index_path
    else
      @categories = Category.all
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    redirect_to company_index_path if @product.destroy
  end

  def show
    @product = Product.find(params[:id])
    
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :description, :user_id, :category_id, :avatar)    
  end
end
