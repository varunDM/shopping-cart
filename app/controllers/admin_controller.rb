#
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_user
  def index
    @user = User.new
    @companies = User.where(role: COMPANY)
    @categories = Category.all
    @purchases = Purchase.all
    @customers = User.where(role: CUSTOMER)

    @activities = ActivityLog.select('action', 'created_at', 'user_id')
                             .order(created_at: :desc)
                             .limit(8)

    @orders = Purchase.select('id', 'created_at', 'first_name', 'products.price')
                      .joins(:product, :bill_address => :user)
                      .order(created_at: :desc)
                      .limit(7)
  end

  def view_orders
    @orders = Purchase.select('id', 'created_at', 'first_name', 'email', 'phone', 'products.price', 'ip')
                      .joins(:product, :bill_address => :user)
                      .order(created_at: :desc)
                      .page params[:page]
    @products = Product.select('products.name AS product_name', 'categories.name AS category_name', 'quantity', 'price')
                       .joins(:category)
  end

  def logs
    @activities = ActivityLog.all.order(created_at: :desc).page params[:page]
  end

  def order_details
    @order = Purchase.select('id', 'created_at', 'first_name', 'email', 'phone', 'products.price', 'ip').joins(:product, :bill_address => :user).find(params[:id])
    @shipping = Purchase.find(params[:id]).bill_address
    @product = Purchase.joins(:product => :category).find(params[:id]).product
  end

  def check_user
    redirect_to home_index_path unless current_user.role == SUPERADMIN
  end
end
