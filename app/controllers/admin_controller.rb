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

    @orders = Purchase.select('id', 'created_at', 'first_name')
                      .joins(:bill_address => :user)
                      .order(created_at: :desc)
                      .limit(7)
  end

  def view_orders
    @orders = Purchase.select('id', 'created_at', 'first_name', 'email', 'phone', 'ip')
                      .joins(:bill_address => :user)
                      .order(created_at: :desc)
                      .page params[:page]
  end

  def logs
    @activities = ActivityLog.all.order(created_at: :desc).page params[:page]
  end

  def order_details
    @order = Purchase.select('id', 'created_at', 'first_name', 'email', 'phone', 'ip').joins(:bill_address => :user).find(params[:id])
    @purchase_products = Purchase.find(params[:id]).purchase_products
    @total = 0
    @purchase_products.each do |purchase_product|
      @total += purchase_product.quantity * purchase_product.product.price
    end
    @shipping = Purchase.find(params[:id]).bill_address
  end

  def check_user
    redirect_to home_index_path unless current_user.role == SUPERADMIN
  end
end
