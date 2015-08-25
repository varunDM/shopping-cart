#
class HomeController < ApplicationController
  layout 'home'
  def index
    @products = Product.all
  end

  def search
    @products = Product.search(params[:query], params[:type])
    render :json => @products.as_json(methods: :image_url)
  end

  def autocomplete
    @results = Product.autocomplete(params[:query])
    p 'mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm'
    @search_results = @results[:product].map do |result| { :label => result.name, :id => result.id, :type => "product" } end
    @search_results += @results[:category].map do |result| { :label=> result.name, :id => result.id, :type => "category"} end
    p @search_results
    render :json => @search_results.as_json
  end
end
