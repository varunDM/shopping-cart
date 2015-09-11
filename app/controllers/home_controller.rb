#
# Activities in home page
#
# @author [qbuser]
#
class HomeController < ApplicationController
  layout 'home'

  # Get all products for home page
  def index
    @products = Product.select('id', 'name', 'description', 'price', 'quantity').all
    @images = @products.map { |product| product.product_images[0].image.url(:thumb) }
  end

  # Search for products or categories based on params[:type]
  #
  def search
    @products = Product.search(params[:query], params[:type])
    render partial: 'results'
  end

  # Populate search list in home page with products and categories
  #
  def autocomplete
    @results = Product.autocomplete(params[:query])
    @search_results = @results[:product].map do |result| { label: result.name, id: result.id, type: 'product' } end
    @search_results += @results[:category].map do |result| { label: result.name, id: result.id, type: 'category' } end
    p @search_results
    render json: @search_results.as_json
  end
end
