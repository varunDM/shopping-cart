#
class HomeController < ApplicationController
  layout 'home'
  def index
    @products = Product.all
  end

  def search
    @products = Product.search(params[:query], params[:type])
    render :json => @products.as_json(methods: :avatar_url)
  end
end
