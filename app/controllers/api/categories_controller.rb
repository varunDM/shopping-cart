#
# [class description]
#
# @author [qbuser]
#
class Api::CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: categories
  end

  def show
    category = Category.find(params[:id])
    products = category.products
    render json: { category: category, products: products}
  end
end
